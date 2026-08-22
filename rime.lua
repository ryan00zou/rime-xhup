-- 数字转换 (金额大写、科学计数、进制转换等)
number_conversion = require("wanxiang/number_conversion")
super_calculator = require("wanxiang/super_calculator")

-- 万象日期时间功能
shijian = require("wanxiang/shijian")

-- 万象快捷键手动排序模块 (Ctrl+j/k/l/p 移动候选词)
local wanxiang = require("wanxiang/wanxiang")
local super_sequence = require("wanxiang/super_sequence")

-- 注册 super_sequence 模块
super_sequence_processor = super_sequence.P
super_sequence_filter = super_sequence.F

-- 英文单词自动大写
word_autocaps = require("word_autocaps")

-- 手动造词编码存储
local zaoci_phrase = require("wanxiang/zaoci_phrase")
zaoci_phrase_filter = zaoci_phrase

-- 超级提示模块
local super_tips = require("wanxiang/super_tips")
super_tips_processor = super_tips