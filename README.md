# NotJen 

## Overview

**Lua Pipeline Runner** is a custom CI/CD tool built using **Rust** and **Lua**. It allows users to define and execute build pipelines in **Lua** and dynamically load external **plugins** for custom jobs and hooks. This system is designed to be extensible, offering a flexible and developer-friendly experience for managing pipelines.

### Key Features:
- **Pipeline as Code**: Pipelines are defined as Lua scripts with stages and jobs.
- **Dynamic Plugin System**: Plugins can be loaded dynamically during the execution of the pipeline, allowing users to add custom jobs and hooks.
- **Hooks**: Plugins can define hooks to run before and after stages.
- **Extensibility**: Developers can extend functionality by writing Lua plugins, eliminating the need to modify the core Rust code.

## Getting Started

### Prerequisites:
- **Rust** (installed via [rustup](https://rustup.rs/))
- **Cargo** (Rust’s package manager, included with Rust)
- **Lua** (embedded via the `mlua` crate)

### How It Works:

1. **Pipeline Definition**: Define your pipeline in a Lua script. The pipeline consists of stages, each of which can have multiple jobs.
2. **Plugin System**: Plugins (written in Lua) can define custom jobs and hooks to be run before and after stages.
3. **Flexible Execution**: The Rust application loads the pipeline and plugins dynamically, allowing users to specify different pipelines and plugins at runtime.

## Running the Pipeline:

1. Create a Lua pipeline file (e.g., `pipeline.lua`) and a plugin file (e.g., `plugin.lua`).
2. Run the Rust application by specifying the Lua files:
   ```sh
   cargo run -- --file lua/pipelines/pipeline.lua --plugin-dir lua/plugins/plugin
   ```
## Extending the System

### Adding More Plugins:
You can add more plugins by placing additional `.lua` files in the `plugins` directory and referencing them in the pipeline. Each plugin can introduce new jobs, hooks, or other features.

## Running Tests

To test the Git Plugin or any other plugin, you can use [Busted](https://lunarmodules.github.io/busted/), a unit testing framework for Lua.

Here’s an example of how to run the test for the `git_plugin`:

```sh
busted lua/plugins/git_plugin_spec.lua
```

This will execute the tests defined in the `git_plugin_spec.lua` file, which checks if a valid command runs without error.

You can extend the test suite by adding more cases to the describe and it blocks for further validation of the plugin's behavior.

