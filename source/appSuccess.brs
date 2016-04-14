Function ShowParagraphScreen() As Void
    port = CreateObject("roMessagePort")
    screen = CreateObject("roParagraphScreen")
    screen.SetMessagePort(port)
    screen.SetTitle("App Purchased")
    screen.AddHeaderText("You have successfully purchased this APP")
    screen.AddParagraph("Congratulations!!!!!!")
    screen.AddParagraph("You have successfully purchased this APP")
    'screen.AddButton(1, "[button text 1]")
    'screen.AddButton(2, "[button text 2]")
    screen.Show()
    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = " roParagraphScreenEvent"
            exit while
        endif
    end while
End Function