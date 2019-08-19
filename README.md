
This is the README file for SAMPLES-ObjectScript. The end of the file has setup instructions.

Use or operation of this code is subject to acceptance of the license available in the code repository for this code.

SAMPLES-ObjectScript is meant for use with the InterSystems IRIS Data Platform.  This code sample is intended to be used with the  [ObjectScript Tutorial](http://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=TOS_Preface).

The `ObjectScript` folder contains 10 files:

* `RightTriangle.cls` is a simple example of a class definition with a few methods.
* `Examples.cls` contains all the examples of methods shown throughout the tutorial.
* Four `DataEntry#.cls` files (1-4) contain the solutions to exercises 1-4.
* Three `Lookup#.cls` files (5-7) contain the completed solutions to exercises 5-7.
* `Person.cls` a simple example of a persistent class.

## Setup instructions
To set up the sample:

1. Clone or [download](http://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=asamples) the repository.
2. If you have not yet created a namespace in InterSystems IRIS, follow the [detailed instructions](http://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GSA_config_namespace_create) to do so.
3. Using Atelier, create a project that's connected to InterSystems IRIS.
4. Right-click your project icon, and click Import. Then select General > File System.
5. Click the Browse button, and browse to the folder for the ObjectScript folder within the repository you downloaded.
6. Select all 10 cls files, and click the checkbox for the Create top-level folder option.
7. Click Finish.

## Setup instructions for IRIS in Docker container

Make sure you have docker and git installed.
1. Clone the repository.
2. Run in a repository folder:
```
# docker-compose build
# docker-compose up -d
```
This will run IRIS in docker container with port for Control Panel on 52791 
and will import all the code into SAMPLES namespace.
3. Open the terminal to IRIS with:
```
# docker-compose exec iris iris session iris
USER>zn "SAMPLES"
SAMPLES>w ##class(ObjectScript.Examples).DoubleByVal(2)
4
```
Work with tutorial

4. Integration with VSCode-ObjectScript
Open the folder of the project in VSCode with installed ObjectScript plugin.
VSCode will compile ObjectScript classes in IRIS container because of prepared .vscode/settings.json
