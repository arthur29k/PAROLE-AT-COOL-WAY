local kys = {}

function kysShowDialog(dialogId, title, text, button1, button0, style, placeholder)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt16(bs, dialogId)
    raknetBitStreamWriteInt8(bs, style)
    raknetBitStreamWriteInt8(bs, #title)
    raknetBitStreamWriteString(bs, title)
    raknetBitStreamWriteInt8(bs, #button1)
    raknetBitStreamWriteString(bs, button1)
    raknetBitStreamWriteInt8(bs, #button0)
    raknetBitStreamWriteString(bs, button0)
    raknetBitStreamEncodeString(bs, text)
    if placeholder then
        raknetBitStreamWriteInt8(bs, #placeholder)
        raknetBitStreamWriteString(bs, placeholder)
    end
    raknetEmulRpcReceiveBitStream(61, bs)
    raknetDeleteBitStream(bs)
end

return kys