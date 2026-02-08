local core = {}

---@enum Language
core.Language = {
  JAPANESE = 'JP',
  ENGLISH = 'EN',
  FRENCH = 'FR',
  ITALIAN = 'IT',
  GERMAN = 'DE',
  SPANISH = 'ES',
  RUSSIAN = 'RU',
  POLISH = 'PL',
  DUTCH = 'NL',
  PORTUGUESE = 'PR',
  PORTUGUESE_BRAZIL = 'PR_BR',
  KOREAN = 'KR',
  CHINESE_HONG_KONG = 'ZH-HK',
  CHINESE_SIMPLIFIED = 'ZH-CN',
  FINNISH = 'FI',
  SWEDISH = 'SV',
  DANISH = 'DA',
  NORWEGIAN = 'NO',
  CZECH = 'CS',
  HUNGARIAN = 'HU',
  SLOVAK = 'SK',
  ARABIC = 'AR',
  TURKISH = 'TR',
  BULGARIAN = 'BG',
  GREEK = 'EL',
  ROMANIAN = 'RO',
  THAI = 'TH',
  UKRAINIAN = 'UA',
  VIETNAMESE = 'VI',
  INDONESIAN = 'ID',
  FICTION = 'FICTION',
  HINDI = 'HI',
  UNKNOWN = 'UNKNOWN',
}

---@type LanguageByIndex
core.LanguageByIndex = {
  [1] = 'JP',
  [2] = 'EN',
  [3] = 'FR',
  [4] = 'IT',
  [5] = 'DE',
  [6] = 'ES',
  [7] = 'RU',
  [8] = 'PL',
  [9] = 'NL',
  [10] = 'PR',
  [11] = 'PR_BR',
  [12] = 'KR',
  [13] = 'ZH-HK',
  [14] = 'ZH-CN',
  [15] = 'FI',
  [16] = 'SV',
  [17] = 'DA',
  [18] = 'NO',
  [19] = 'CS',
  [20] = 'HU',
  [21] = 'SK',
  [22] = 'AR',
  [23] = 'TR',
  [24] = 'BG',
  [25] = 'EL',
  [26] = 'RO',
  [27] = 'TH',
  [28] = 'UA',
  [29] = 'VI',
  [30] = 'ID',
  [31] = 'FICTION',
  [32] = 'HI',
  [33] = 'UNKNOWN',
}

---@enum RankType
core.RankType = {
  LOW = 'LOW_RANK',
  HIGH = 'HIGH_RANK',
  MASTER = 'MASTER_RANK',
}

core.MHRankArray = {
  [0] = core.RankType.LOW,
  [1] = core.RankType.HIGH,
  [2] = core.RankType.MASTER,
}

return core
