# OpenAI API Setup for Word Court

## Getting Your OpenAI API Key

1. Visit [OpenAI's API platform](https://platform.openai.com/api-keys)
2. Sign up or log in to your account
3. Navigate to "API Keys" in the dashboard
4. Click "Create new secret key"
5. Copy the generated key (it starts with `sk-`)

## Setting Up Your Environment

### For Development (Local)

Create a `.env` file in your project root:

```bash
# Add this to .env (create the file if it doesn't exist)
OPENAI_API_KEY=sk-your-actual-api-key-here
```

Then load it before starting the server:

```bash
# Load environment variables and start server
source .env && mix phx.server
```

### Alternative: Export directly

```bash
# Export the environment variable
export OPENAI_API_KEY=sk-your-actual-api-key-here

# Start the server
mix phx.server
```

## Testing the Setup

1. Set your API key using one of the methods above
2. Start the server: `mix phx.server`
3. Visit http://localhost:4000
4. Submit a disputed word (try "QI" or "ZYZZYVA")
5. Watch the AI courtroom come to life!

## Configuration Details

The app is configured to use:
- **Model**: GPT-3.5-turbo (fast and cost-effective)
- **Max tokens**: 500 per response
- **Temperature**: 0.7 (balanced creativity)

You can modify these settings in `config/config.exs` if needed.

## Troubleshooting

- **"No API key"** error: Make sure OPENAI_API_KEY is set
- **Rate limiting**: Wait a moment between requests
- **Invalid key**: Double-check your API key format

Ready to see AI lawyers in action! 🏛️⚖️

