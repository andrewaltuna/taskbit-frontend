const createUserMutation = r"""
            mutation($username: String!, $first_name: String!, $last_name: String!, $password: String!, $avatar: String!) {
              signUp (signUpDetails: {
                username: $username
                first_name: $first_name
                last_name: $last_name
                password: $password
                avatar: $avatar
              })
            }
          """;

const updateAvatarMutation = r"""
            mutation($avatar: String!) {
              changeAvatar (
                avatar: $avatar
              ) {
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
            mutation($name: String!, $description: String, $difficulty: String, $dateDue: String) {
              createTask (taskDetails: {
                name: $name
                description: $description
                difficulty: $difficulty
                dateDue: $dateDue
              })
            }
          """;

const updateTaskMutation = r"""
            mutation($taskId: String!, $name: String!, $description: String, $difficulty: String, $dateDue: String) {
              updateTask (editTaskDetails: {
                taskId: $taskId
                name: $name
                description: $description
                difficulty: $difficulty
                dateDue: $dateDue
              })
            }
          """;

const completeTaskMutation = r"""
            mutation($taskId: String!) {
              completeTask (
                taskId: $taskId
              )
            }
          """;

const deleteTaskMutation = r"""
            mutation($taskId: String!) {
              deleteTask (
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
                difficulty
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
              bossesSlain
              enemiesSlain
              tasksCompleted
              stagesCompleted
            }
          }
          """;
