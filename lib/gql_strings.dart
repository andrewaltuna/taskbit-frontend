const createUserMutation = r"""
            mutation($username: String!, $first_name: String!, $last_name: String!, $password: String!, $avatar: String!) {
              signUp (signUpDetails: {
                username: $username
                first_name: $first_name
                last_name: $last_name
                password: $password
                avatar: $avatar
              }) {
                username
              }
            }
          """;

const loginQuery = r"""
            query($username: String!, $password: String!) {
              signIn(loginDetails: {
                username: $username
                password: $password
              }) {
                username
                avatar
                first_name
                last_name
                stage
                substage
                accessToken
                currentEnemy { 
                  currentHp
                  rootenemy {
                    name
                    maxHp
                    sprite
                  }
                }
              }
            }
          """;

const createTaskMutation = r"""
            mutation($name: String!, $description: String, $dateDue: String) {
              newTask (taskDetails: {
                name: $name
                description: $description
                dateDue: $dateDue
              }) {
                name
              }
            }
          """;

const completeTaskMutation = r"""
            mutation($taskId: String!) {
              completeTask (
                taskId: $taskId
              )
            }
          """;

const taskEnemyQuery = r"""
          query {
            getTaskEnemy {
              tasks {
                id
                name
                description
                dateDue
                dateCompleted
              }
              currentEnemy {
                currentHp
                rootenemy {
                    name
                    sprite
                    maxHp
                    type
                }
              }
              stage
              substage
            }
          }
          """;
