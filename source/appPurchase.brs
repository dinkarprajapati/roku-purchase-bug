Function showPurchaseScreen() as void
    this = {
        screen: CreateObject("roListScreen")
        port: CreateObject("roMessagePort")
        store: CreateObject("roChannelStore")
        store_items: []
        returnBeforeLoading: 0
        MakePurchase: make_purchase
        GetChannelCatalog: get_channel_catalog
        GetContentList: get_content_list
        OrderStatusDialog: order_status_dialog
    }
    this.screen.SetMessagePort(this.port)
    this.store.SetMessagePort(this.port)
    this.screen.SetHeader("Choose your Subscription option:")
    this.screen.Show()
    this.GetChannelCatalog()
    
    while (true)
        msg = wait(0, this.port)
        print type(msg)
        if (type(msg) = "roListScreenEvent")
            if (msg.isListItemSelected())
                index = msg.GetIndex()
                this.MakePurchase(index)
            else if msg.isScreenClosed() then
                print "closed"
                return
            endif
        else if (type(msg) = "roChannelStoreEvent")
            if msg.IsRequestSucceeded() then
                print msg.GetResponse()                
                ShowParagraphScreen()
            else if msg.IsRequestFailed() then
                print msg.isRequestFailed(); "------------"
            else if msg.isRequestInterrupted() then
                print "interrupted"
            end if        
        end if
    end while
End Function

Function make_purchase(index as integer) as void
    result = m.store.GetUserData()
    if (result = invalid)
        return
    endif
    order = [{
        code: m.store_items[index].code
        qty: 1        
    }]
    val = m.store.SetOrder(order)
    res = m.store.DoOrder()
    if (res = true)
        m.OrderStatusDialog(true, m.store_items[index].Title)
    else
        m.OrderStatusDialog(false, m.store_items[index].Title)
    endif
End Function

Function get_content_list(items) as void
    i = 0
    arr = []
    for each item in items
        'print "********************* Item " + Stri(i) + " *********************" 
        'print item
        i = i+1    
        list_item = {
                    Title: item.name
                    ID: stri(i)
                    code: item.code
                    cost: item.cost
        }
        m.store_items.Push(list_item)
    end for
End Function

Function get_channel_catalog() as void
    print "***** Channel Catalog *****"
    m.store.GetCatalog()
    while true
    msg = wait(0, m.port)
        if (type(msg) = "roChannelStoreEvent")
            if (msg.isRequestSucceeded())
                m.GetContentList(msg.GetResponse())
                m.screen.SetContent(m.store_items)
                m.screen.Show()
            endif
            exit while  
        else if (msg.isRequestFailed())
            print "***** Failure: " + msg.GetStatusMessage() + " Status Code: " + stri(msg.GetStatus()) + " *****"
        else if msg.isScreenClosed() then
            m.returnBeforeLoading = 1
            print "closed here"
            exit while
        endif
    end while
    
End Function

Function order_status_dialog(success as boolean, item as string) as void
    dialog = CreateObject("roMessageDialog")
    port = CreateObject("roMessagePort")
    dialog.SetMessagePort(port)
    if (success = true)
        dialog.SetTitle("Order Completed Successfully")
        str = "Your Purchase of " + item + " Completed Successfully"
    else
        dialog.SetTitle("Order Failed")
        str = "Your Purchase of " + item + " Failed"
    endif
    dialog.SetText(str)
    dialog.AddButton(1, "OK")
    dialog.EnableBackButton(true)
    dialog.Show()

    while true
        dlgMsg = wait(0, dialog.GetMessagePort())
        If type(dlgMsg) = "roMessageDialogEvent"
            if dlgMsg.isButtonPressed()
                if dlgMsg.GetIndex() = 1
                    exit while
                end if
            else if dlgMsg.isScreenClosed()
                exit while
            end if
        end if
    end while

End Function

