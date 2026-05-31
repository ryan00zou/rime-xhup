-- 金额大写转换
number_translator = require("wanxiang/number_translator")
super_calculator = require("wanxiang/super_calculator")

-- 万象日期时间功能
shijian = require("wanxiang/shijian")

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

-- 英文输入相关
cn_en_custom = require("cn_en_custom")

-- 英文单词自动大写
word_autocaps = require("word_autocaps")