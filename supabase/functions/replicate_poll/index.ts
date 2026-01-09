import { serve } from "https://deno.land/std@0.177.0/http/server.ts";

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
};

serve(async (req) => {
    // Handle CORS preflight requests
    if (req.method === 'OPTIONS') {
        return new Response(null, { headers: corsHeaders });
    }

    try {
        const { predictionUrl } = await req.json();
        const replicateApiKey = Deno.env.get('REPLICATE_API_KEY');

        if (!replicateApiKey) {
            throw new Error('REPLICATE_API_KEY not configured');
        }

        if (!predictionUrl) {
            throw new Error('predictionUrl is required');
        }

        console.log(`🔄 Polling prediction: ${predictionUrl}`);

        // Poll the prediction status
        const pollResponse = await fetch(predictionUrl, {
            method: 'GET',
            headers: {
                'Authorization': `Token ${replicateApiKey}`,
                'Content-Type': 'application/json',
            },
        });

        if (!pollResponse.ok) {
            const errorText = await pollResponse.text();
            console.error(`❌ Replicate Poll Error: ${pollResponse.status} - ${errorText}`);
            throw new Error(`Replicate poll failed: ${pollResponse.status}`);
        }

        const prediction = await pollResponse.json();

        console.log(`📊 Prediction status: ${prediction.status}`);

        return new Response(
            JSON.stringify({
                status: prediction.status,
                output: prediction.output,
                error: prediction.error,
            }),
            {
                headers: { ...corsHeaders, 'Content-Type': 'application/json' }
            }
        );

    } catch (error) {
        console.error('❌ Poll Edge Function Error:', error);
        return new Response(
            JSON.stringify({
                error: error.message || 'Unknown error occurred'
            }),
            {
                status: 500,
                headers: { ...corsHeaders, 'Content-Type': 'application/json' }
            }
        );
    }
});
