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
        const { prompt } = await req.json();
        const replicateApiKey = Deno.env.get('REPLICATE_API_KEY');

        if (!replicateApiKey) {
            throw new Error('REPLICATE_API_KEY not configured');
        }

        console.log(`🖼️ Generating image with prompt: ${prompt}`);

        // Start prediction
        const startResponse = await fetch('https://api.replicate.com/v1/predictions', {
            method: 'POST',
            headers: {
                'Authorization': `Token ${replicateApiKey}`,
                'Content-Type': 'application/json',
                'Prefer': 'wait',
            },
            body: JSON.stringify({
                version: "39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b",
                input: {
                    prompt: `A realistic photo of a beautiful young woman, ${prompt}, high quality, 8k, photorealistic`,
                    negative_prompt: "cartoon, illustration, anime, ugly, deformed, low quality, pixelated, blur",
                    width: 768,
                    height: 1024,
                },
            }),
        });

        if (!startResponse.ok) {
            const errorText = await startResponse.text();
            console.error(`❌ Replicate API Error: ${startResponse.status} - ${errorText}`);
            throw new Error(`Replicate API failed: ${startResponse.status}`);
        }

        const prediction = await startResponse.json();
        const status = prediction.status;

        // If already succeeded (rare with 'Prefer: wait')
        if (status === 'succeeded' && prediction.output && prediction.output.length > 0) {
            console.log(`✅ Image ready immediately: ${prediction.output[0]}`);
            return new Response(
                JSON.stringify({
                    status: 'succeeded',
                    output: prediction.output,
                    urls: { get: prediction.urls?.get }
                }),
                {
                    headers: { ...corsHeaders, 'Content-Type': 'application/json' }
                }
            );
        }

        // Return the prediction object for polling
        console.log(`⏳ Prediction started: ${prediction.id}, status: ${status}`);
        return new Response(
            JSON.stringify({
                status: prediction.status,
                output: prediction.output,
                urls: { get: prediction.urls?.get }
            }),
            {
                headers: { ...corsHeaders, 'Content-Type': 'application/json' }
            }
        );

    } catch (error) {
        console.error('❌ Edge Function Error:', error);
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
