# Word Court 🏛️

An AI-powered courtroom game where players submit words to be judged by AI prosecutor, defender, and judge agents.

## 🎮 Game Overview

Word Court is an interactive Phoenix LiveView application that puts words on trial! Players submit a word, and three AI agents debate its merits:

- **🔴 Prosecutor**: Argues why the word is problematic or inappropriate
- **🔵 Defender**: Defends the word and argues for its value
- **⚖️ Judge**: Makes the final ruling based on the arguments

## ✨ Features

### Core Gameplay
- **Real-time courtroom proceedings** with WebSocket connections
- **AI-powered debates** using OpenAI's GPT models
- **Dynamic case progression** through prosecution → defense → judgment phases
- **Vintage newspaper design** with sepia tones and classic typography

### AI Configuration System
- **Individual agent personalities** with separate temperature, max_tokens, and model settings
- **Sophisticated presets**: Professional Court, Comedy Court, Strict Academy, Wild West Court
- **Admin interface** for creating and managing AI configurations
- **Real-time preview** of active settings

### Technical Features
- **Phoenix LiveView** for real-time updates
- **OpenAI API integration** with proper error handling and fallbacks
- **SQLite database** for storing configurations and game state
- **Responsive design** with TailwindCSS
- **Git-based deployment** ready for Fly.io

## 🚀 Getting Started

### Prerequisites
- Elixir 1.15+
- Phoenix 1.7+
- OpenAI API key

### Installation

1. Clone the repository:
```bash
git clone https://github.com/davidhmartin/word-court.git
cd word-court
```

2. Install dependencies:
```bash
mix deps.get
```

3. Set up the database:
```bash
mix ecto.setup
```

4. Configure your OpenAI API key:
```bash
echo "OPENAI_API_KEY=your_api_key_here" > .env
```

5. Start the server:
```bash
mix phx.server
```

Visit `http://localhost:4000` to start playing!

## 🎯 How to Play

1. **Submit a Word**: Enter any word you'd like to put on trial
2. **Watch the Prosecution**: The AI prosecutor argues against your word
3. **See the Defense**: The AI defender argues in favor of your word
4. **Await Judgment**: The AI judge makes the final ruling
5. **Learn the Verdict**: Discover whether your word is guilty or innocent!

## ⚙️ AI Configuration

Access the admin panel at `/ai-settings` to:
- Create custom AI personalities
- Adjust creativity levels (temperature) for each agent
- Set response lengths (max tokens)
- Choose different GPT models
- Switch between preset court styles

### Preset Configurations
- **Professional Court**: Formal, legal proceedings
- **Comedy Court**: Humorous, entertaining debates
- **Strict Academy**: Conservative, traditional judgments
- **Wild West Court**: Frontier justice with colorful language

## 🛠️ Technical Architecture

### Phoenix LiveView Components
- `GameLive`: Main game interface and real-time updates
- `AiSettingsLive`: Admin interface for AI configuration
- `Layouts.app`: Vintage newspaper design system

### Core Modules
- `WordCourt.AiCourtroom`: OpenAI API integration and response handling
- `WordCourt.AiSettings`: Configuration management with presets
- `WordCourt.Game`: Game state and progression logic

### Database Schema
- Individual agent settings (temperature, max_tokens, model)
- Configuration presets with full customization
- Proper validation and fallback handling

## 🎨 Design System

The application features a vintage newspaper aesthetic:
- **Typography**: Times New Roman with classic serif styling
- **Color Palette**: Sepia backgrounds with red accent highlights
- **Layout**: Column-based design mimicking historical newspapers
- **Responsive**: Mobile-friendly with collapsible sections

## 🚀 Deployment

The application is configured for Fly.io deployment:

```bash
fly deploy
```

Environment variables needed:
- `OPENAI_API_KEY`: Your OpenAI API key
- `SECRET_KEY_BASE`: Phoenix secret (auto-generated)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🎪 Fun Examples

Try putting these words on trial:
- **"pineapple"** (on pizza) - A classic controversial topic
- **"moist"** - The word everyone loves to hate
- **"algorithm"** - Modern technology on trial
- **"Shakespeare"** - Can classic literature be guilty?

## 🔧 Development

### Running Tests
```bash
mix test
```

### Code Formatting
```bash
mix format
```

### Database Reset
```bash
mix ecto.reset
```

## 📞 Support

If you encounter any issues or have questions:
1. Check the [Issues](https://github.com/davidhmartin/word-court/issues) page
2. Create a new issue with detailed information
3. Include error messages and steps to reproduce

---

**Built with ❤️ using Phoenix LiveView and OpenAI**

*Put your words on trial today!*
