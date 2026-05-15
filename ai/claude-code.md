# Claude Code

Claude Code is an agentic AI tool used for software development.  

These notes will be on using Claude Code from the command line on Linux.  

## Authentication

When

You can set the `CLAUDE_API_KEY` environment variable to your API key to authenticate with the Claude API.

## Customization

Claude Code can be customized in a number of ways. 

One way is by setting environment variables, another is by creating instruction files. 

### Environment Variables
- `CLAUDE_MODEL` - Set this to the name of the Claude model you want to use
  (e.g. `claude-2`, `claude-instant-100k`, etc.).

- `CLAUDE_TEMPERATURE` - Set this to a number between 0 and 1 to control the randomness of the output. Higher values will produce more creative responses, while lower values will produce more deterministic responses.

- `CLAUDE_MAX_TOKENS` - Set this to the maximum number of tokens that Claude 
  should generate in its response. The default is 2048 tokens.

- `CLAUDE_TOP_P` - Set this to a number between 0 and 1 to control the 
  diversity of the output. Higher values will produce more diverse responses, 
  while lower values will produce more focused responses.

### Instruction Files

There are several files that are read by default for instructions and
configuration:

- `CLAUDE.md`: Custom instructions for Claude.  

- `.claudeignore`: Like .gitignore
- `~/.claude/settings.json`: Global user configurations.  
- `project/.claude/settings.json`: Project-level config for Claude.

- `SKILL.md`: Custom slash commands for Claude CLI.


You can create instruction files to provide specific instructions to Claude Code for different tasks.
For example, you could create a file called `generate_code.txt` with the following content:

```
# Generate Code Instructions
- Use the latest version of the Claude model.
- Focus on generating clean and efficient code.
- Provide comments in the code to explain your logic.
```
Then, when you run Claude Code, you can specify this instruction file to guide the output:

```bash
claude-code --instructions generate_code.txt
```

