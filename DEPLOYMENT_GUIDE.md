# Deploying Supabase Edge Functions

This guide walks through deploying the Replicate proxy Edge Functions to Supabase.

## Prerequisites

- Supabase CLI installed
- Supabase project initialized
- Replicate API key

## Step 1: Install Supabase CLI

If you haven't already, install the Supabase CLI:

```bash
npm install -g supabase
```

## Step 2: Login to Supabase

```bash
supabase login
```

This will open a browser window to authenticate.

## Step 3: Link Your Project

Navigate to your project directory and link it to your Supabase project:

```bash
cd e:/AI\ gF/craveai
supabase link --project-ref YOUR_PROJECT_REF
```

Replace `YOUR_PROJECT_REF` with your actual Supabase project reference (found in your Supabase dashboard URL).

## Step 4: Set the Replicate API Key as a Secret

```bash
supabase secrets set REPLICATE_API_KEY=your_replicate_api_key_here
```

Replace `your_replicate_api_key_here` with your actual Replicate API key.

## Step 5: Deploy the Edge Functions

Deploy both Edge Functions:

```bash
supabase functions deploy replicate-proxy --no-verify-jwt
supabase functions deploy replicate-poll --no-verify-jwt
```

The `--no-verify-jwt` flag allows the functions to be called without authentication (they're protected by your API keys being server-side).

## Step 6: Note Your Function URLs

After deployment, note your function URLs. They will be:

- Proxy: `https://YOUR_PROJECT_REF.supabase.co/functions/v1/replicate-proxy`
- Poll: `https://YOUR_PROJECT_REF.supabase.co/functions/v1/replicate-poll`

## Step 7: Verify SUPABASE_URL in .env

Make sure your `.env` file has the correct `SUPABASE_URL`:

```env
SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co
```

The Flutter app will automatically construct the function URLs from this.

## Step 8: Test the Deployment

Run your Flutter app and try generating an image:

```bash
flutter run -d chrome
```

Check the console for logs confirming the proxy is being used.

## Troubleshooting

### Function Not Found

If you get a "Function not found" error:
1. Check that the function is deployed: `supabase functions list`
2. Verify your project ref is correct
3. Try redeploying: `supabase functions deploy replicate-proxy --no-verify-jwt`

### API Key Not Working

If the Replicate API returns authentication errors:
1. Verify the secret is set: `supabase secrets list`
2. Re-set the secret if needed: `supabase secrets set REPLICATE_API_KEY=your_key`
3. Redeploy the function after setting secrets

### CORS Errors Still Appearing

If you still see CORS errors:
1. Verify you're using the correct Supabase URL in `.env`
2. Check that the Edge Function is returning proper CORS headers
3. Clear your browser cache and reload

## Logs and Monitoring

View real-time logs from your Edge Functions:

```bash
supabase functions logs replicate-proxy
supabase functions logs replicate-poll
```

## Updating Functions

When you make changes to the Edge Function code, redeploy:

```bash
supabase functions deploy replicate-proxy --no-verify-jwt
supabase functions deploy replicate-poll --no-verify-jwt
```
