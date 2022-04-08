
alias Backend.Repo
alias Backend.Accounts.User
alias Backend.Accounts.Users


Repo.insert! %User{email: "test@test.com", encrypted_password: "12345678aA#" ,
boards: [%{name: "Board one",
  lists: [%{title: "List A",
  tasks: [%{title: "Task 1", description: "Testing task one" }]

  }]
}, %{name: "Board two"} ]
}
|> Repo.preload(:boards)



user = %{email: "tessst@test.com", password: "12345678aA#"}

Users.create_user(user)
