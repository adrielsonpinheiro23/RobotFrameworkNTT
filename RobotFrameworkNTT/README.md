# RobotFrameworkNTT

This project contains automated tests for both GUI and API functionalities of the Serverest application using Robot Framework. The tests are organized into separate directories for GUI and API tests.

Documentation for Zoomba Library: https://pypi.org/project/robotframework-zoomba/

pip install robotframework-zoomba --upgrade

pip install robotframework-requests

pip install robotframework-faker

## Project Structure

```
.idea/
API/
    pages/
        KeywordsAPI.robot
    tests/
        FeatureTestsApi.robot
GUI/
    pages/
        KeywordsGUI.robot
    tests/
        FeatureTests.robot
resource/
    resource.resource
```

## Prerequisites

- Python 3.11
- Robot Framework
- Zoomba Library
- FakerLibrary
- XML Library
- RequestsLibrary
- String Library
- Collections Library
- Chrome Browser

## Installation

1. Clone the repository:
    ```sh
    git clone <repository-url>
    cd RobotFrameworkNTT
    ```

2. Create a virtual environment and activate it:
    ```sh
    python -m venv myvenv
    source myvenv/bin/activate  # On Windows use `myvenv\Scripts\activate`
    ```

3. Install the required libraries:
    ```sh
    pip install robotframework
    pip install robotframework-zoomba
    pip install robotframework-faker
    pip install robotframework-requests
    ```

## Running the Tests

### GUI Tests

1. Navigate to the `GUI/tests` directory:
    ```sh
    cd GUI/tests
    ```

2. Run the tests:
    ```sh
    robot FeatureTests.robot
    ```

### API Tests

1. Navigate to the `API/tests` directory:
    ```sh
    cd API/tests
    ```

2. Run the tests:
    ```sh
    robot FeatureTestsApi.robot
    ```

## Test Cases

### GUI Test Cases

- **TC1: Perform Login**
  - Creates a new user
  - Logs in to the Serverest application
  - Verifies that the non-admin user is at the landing page

- **TC2: Search for a product And Add to the List**
  - Creates a new user
  - Logs in to the Serverest application
  - Checks available products
  - Searches for a product in the search bar
  - Clicks on the product details
  - Adds the item to the list

- **TC3: Perform Registration As Admin**
  - Creates a new user with admin privileges

### API Test Cases

- **TC1: Cadastrar um novo usuário com sucesso na ServerRest**
  - Verifies that the user was successfully registered

- **TC2: Cadastrar um usuário já existente**
  - Attempts to register an already existing user
  - Verifies that the API does not allow duplicate registration

- **TC3: Consultar os dados de um novo usuário**
  - Consults the data of the newly registered user
  - Verifies the returned data

- **TC4: Criar e Validar Produto na ServerRest**
  - Authenticates the user
  - Registers a new product
  - Consults the newly created product
  - Verifies the product data

## Keywords

### GUI Keywords

Defined in [KeywordsGUI.robot](GUI/pages/KeywordsGUI.robot):

- `I create a new user`
- `I Login at the serverest Application`
- `Non Admin User is At Landing Page`
- `I search for ${PRODUCT} in search bar`
- `Check available products`
- `I click on Details`
- `Add the Item to the List`
- `I Logout the application`

### API Keywords

Defined in [KeywordsAPI.robot](API/pages/KeywordsAPI.robot):

- `Criar um usuário novo`
- `Cadastrar o usuário criado na ServerRest`
- `Criar Sessão na ServerRest`
- `Autenticar Usuário na ServerRest`
- `Conferir se o usuário foi cadastrado corretamente`
- `Repetir o cadastro do usuário`
- `Verificar se a API não permitiu o cadastro repetido`
- `Consultar os dados do novo usuário`
- `Conferir os dados retornados`
- `Cadastrar Produto na ServerRest`
- `Consultar Produto Criado`

## Resources

Common resources are defined in [resource.resource](resource/resource.resource).

## Usage Examples

### Running a Specific GUI Test Case

To run a specific test case from the GUI tests, use the `--test` option followed by the test case name. For example, to run the "TC1: Perform Login" test case:

```sh
robot --test "TC1: Perform Login" GUI/tests/FeatureTests.robot
```

### Running a Specific API Test Case

To run a specific test case from the API tests, use the `--test` option followed by the test case name. For example, to run the "TC1: Cadastrar um novo usuário com sucesso na ServerRest" test case:

```sh
robot --test "TC1: Cadastrar um novo usuário com sucesso na ServerRest" API/tests/FeatureTestsApi.robot
```

### Running Tests with Tags

You can also run tests based on tags. For example, if you have tagged your tests with `smoke`, you can run all smoke tests using:

```sh
robot --include smoke GUI/tests/FeatureTests.robot
```

## Notes

- Ensure that the Chrome browser is installed and accessible in the system path.
- The base URLs for the application are defined in the `resource.resource` file.

Feel free to explore and modify the test cases and keywords as needed. Happy testing!