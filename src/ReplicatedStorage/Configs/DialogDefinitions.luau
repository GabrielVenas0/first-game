local Public= {
  withQuest = {
    Quest_1 = {
      Pages = {
        {
          Text = "Mensagem de introdução",
          Options = { "Continue", "Bye" }
        },
        {
          Text = "Mensagem da Quest",
          Options = { "Accept Quest", "Nevermind"}
        },
        {
          Text = "Mensagem de agradecimento por aceitar a quest",
          Options = { "Bye" }
        },
        {
          Text = "Mensagem para quando o jogador recusar/bye",
          Options = {}
        }
      },
    }
  },

  withoutQuest = {
    OldForger = {
      Dialogs = {
        "Sem Quest #1",
        "Sem Quest #2",
        "Sem Quest #3",
      }
    }
  }
}

return Public