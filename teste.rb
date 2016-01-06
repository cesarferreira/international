languages = [
  {
    :language => ':pt',
    :items => [{
      :key => "THANKS",
      :translation => "obrigado"
      },
      {
        :key => "GOODBYE",
        :translation => "adeus"
      }
      ] }
    ]


    puts languages.select {|k| k[:language]==":pt"}
