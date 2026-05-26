function date_translator(input, seg)
   if (input == "orq") then
      --- Candidate(type, start, end, text, comment)
      yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_ %d"), " "))
      yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), ""))
      yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), " "))
   end
end

function time_translator(input, seg)
   if (input == "ouj") then
      local cand = Candidate("time", seg.start, seg._end, os.date("%H:%M"), " ")
      cand.quality = 1
      yield(cand)
   end
end

calculator_translator = require("calculator_translator")

-- 万象快捷键手动排序模块 (Ctrl+j/k/l/p 移动候选词)
local wanxiang = require("wanxiang/wanxiang")
local super_sequence = require("wanxiang/super_sequence")

-- 注册 super_sequence 模块
super_sequence_processor = super_sequence.P
super_sequence_filter = super_sequence.F

-- 万象快捷键调频模块
local wanxiang = require("wanxiang/wanxiang")
local user_predict = require("wanxiang/user_predict")
local super_sequence = require("wanxiang/super_sequence")

-- 注册 user_predict 模块
user_predict_processor = user_predict.P
user_predict_translator = user_predict.T
user_predict_filter = user_predict.F

-- 注册 super_sequence 模块
super_sequence_processor = super_sequence.P
super_sequence_filter = super_sequence.F