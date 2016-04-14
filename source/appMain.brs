Sub Main()
    app = CreateObject("roAppManager")
    port=CreateObject("roMessagePort")
    screen = CreateObject("roPosterScreen")
    screen.SetMessagePort(port)
    screen.SetListStyle("arced-landscape")
    showOptions = [        
        {
            ShortDescriptionLine1:"BUY",
            ShortDescriptionLine2:"Purchase subscription"
        }
    ]
    screen.SetContentList(showOptions)
    screen.Show()
    
    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roPosterScreenEvent" then
            if msg.isListItemSelected() then
                if msg.GetIndex() = 0 then 
                   showPurchaseScreen()
                end if
            else if msg.isScreenClosed() then
                return
            end if
        end If
    end while 
End Sub