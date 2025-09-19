> [!IMPORTANT]
> Ya implemente la interfaz, pero para **compilar y ejecutar** el proyecto deben usar los siguientes comandos desde la raíz del repositorio:
> ```bash
> java -jar lib/jflex-full-1.9.1.jar src/lexer/Analizador.flex
> javac -cp "lib/flatlaf-3.5.jar;src" src/lexer/Main.java -d bin  
> java  -cp "bin;lib/flatlaf-3.5.jar" lexer.Main 
> ```
                     
## Getting Started

Welcome to the VS Code Java world. Here is a guideline to help you get started to write Java code in Visual Studio Code.

## Folder Structure

The workspace contains two folders by default, where:

- `src`: the folder to maintain sources
- `lib`: the folder to maintain dependencies

Meanwhile, the compiled output files will be generated in the `bin` folder by default.

> If you want to customize the folder structure, open `.vscode/settings.json` and update the related settings there.

## Dependency Management

The `JAVA PROJECTS` view allows you to manage your dependencies. More details can be found [here](https://github.com/microsoft/vscode-java-dependency#manage-dependencies).


javac -cp "lib/flatlaf-3.5.jar;src" src/lexer/Main.java -d bin  
java  -cp "bin;lib/flatlaf-3.5.jar" lexer.Main  