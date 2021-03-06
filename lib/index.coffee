i18n = require('./locales/en.js')
_format = require('./format')
_parser = require('./parser')

# Returns diff in days between two dates
#
# @param {Date} date1
# @param {Date} date2
# @param {Boolean} abs if need to get absolute value
#
# @return {Number} in days
diff = (date1, date2, abs) ->
  _diff = if abs then Math.abs(date1 - date2) else date1 - date2
  Math.ceil(_diff / (1000 * 3600 * 24))

# Returns days in current month
#
# @param {Date} date
#
# @return {Number}
daysInMonth = (date = new Date()) ->
  date = new Date(date)
  date.setMonth(date.getMonth() + 1)
  date.setDate(0)
  date.getDate()

# Add days to date
#
# @param {Date} date
# @param {Number} days
#
# @return {Date} new Date instance
addDays = (date = new Date(), days) ->
  date = new Date(date)
  date.setDate(date.getDate() + days)
  date

# Add months to date
#
# @param {Date} date
# @param {Number} months
#
# @return {Date} new Date instance
addMonths = (date = new Date(), months) ->
  date = new Date(date)
  date.setDate(1)
  date.setMonth(date.getMonth() + months)
  date

# Add years to date
#
# @param {Date} date
# @param {Number} years
#
# @return {Date} new Date instance
addYears = (date = new Date(), years) ->
  date = new Date(date)
  date.setYear(date.getFullYear() + years)
  date

# Range by days from startDate to returnDate
#
# @param {Date} startDate
# @param {Date} endDate
#
# @return {[Date]} Array of Dates by dats
getDatesRange = (startDate, endDate) ->
  start = new Date(startDate)
  end = new Date(endDate)
  range = [startDate]
  while start < end
    newDate = addDays(start, 1)
    range.push(newDate)
    start = newDate
  range

# Range by months from startDate to returnDate
#
# @param {Date} startDate
# @param {Date} endDate
#
# @return {[Date]} Array of Dates by months
getDatesMonthRange = (startDate, endDate) ->
  start = new Date(startDate)
  start.setDate(1)
  end = new Date(endDate)
  end.setDate(1)
  range = [startDate]
  while start < end
    newDate = addMonths(start, 1)
    range.push(newDate)
    start = newDate
  range

# year is leap?
#
# @param {Date|Number} ) The Date instance or full year number.
#
# @return {Boolean}
isLeap = (year = new Date()) ->
  year = year.getFullYear() if year instanceof Date
  new Date(year, 1, 29).getMonth() is 1

# Returns true if month and year is equals
#
# @param {Date} firstDate
# @param {Date} lastDate  The [description].
#
# @return {Boolean}
isEqualMonths = (firstDate = new Date(), lastDate = new Date) ->
  return false if not Date.parse(firstDate) or not Date.parse(lastDate)
  firstDate.getMonth() is lastDate.getMonth() and
    firstDate.getFullYear() is lastDate.getFullYear()

# Returns true if day, month and year is equals
#
# @param {Date} firstDate
# @param {Date} lastDate  The [description].
#
# @return {Boolean}
isEqualDates = (firstDate = new Date(), lastDate = new Date()) ->
  return false if not Date.parse(firstDate) or not Date.parse(lastDate)
  firstDate.getDate() is lastDate.getDate() and isEqualMonths(firstDate, lastDate)

isEqual = (firstDate = new Date(), lastDate = new Date(), deep = 'day') ->
  switch deep
    when 'year' then firstDate.getFullYear() is lastDate.getFullYear()
    when 'month' then isEqualMonths(firstDate, lastDate)
    when 'day' then isEqualDates(firstDate, lastDate)
    when 'hour'
      isEqualDates(firstDate, lastDate) and
        firstDate.getHours() is lastDate.getHours()
    when 'minute'
      isEqualDates(firstDate, lastDate) and
        firstDate.getHours() is lastDate.getHours() and
            firstDate.getMinutes() is lastDate.getMinutes()
    when 'second'
      isEqualDates(firstDate, lastDate) and
        firstDate.getHours() is lastDate.getHours() and
            firstDate.getMinutes() is lastDate.getMinutes() and
              firstDate.getSeconds() is lastDate.getSeconds()
    else firstDate is lastDate

lastMonthDate = (date) ->
  new Date(date)
  date = addMonths(date, 1)
  date.setDate(0)
  date

isDateInRange = (date, min, max) ->
  return false if not Date.parse(date)
  [min, max] = [min || new Date(null), max || Infinity]
  minLimit = isEqualDates(date, min) or min <= date
  maxLimit = isEqualDates(date, max) or max >= date
  minLimit && maxLimit

getMonthDates = (date = new Date()) ->
  date = new Date(date)
  date.setDate(1)
  addDays(date, i) for i in [0..lastMonthDate(date).getDate() - 1]

setLocale = (locale) ->
  i18n = locale

getCurrentLocale = (key) ->
  return i18n unless key
  i18n[key]

# Format date with pattern
#
# @param {Date} date
# @param {String} format
# @param {Object} i18n
#
# @return {String}
format = (date, format, genitive, locale) ->
  _format(date, format, genitive, locale || i18n)

parse = (str, format, locale) ->
  _parser(str, format, locale || i18n)

utc = (date = new Date()) ->
  new Date(date.getTime() + date.getTimezoneOffset() * 60000)

dayOfYear = (date = new Date()) ->
  date = new Date(date.getFullYear(), date.getMonth(), date.getDate())
  start = new Date(date.getFullYear(), 0, 0)
  diff(date, start)

module.exports = {
  format,
  diff,
  daysInMonth,
  getDatesRange,
  getDatesMonthRange,
  getMonthDates,
  isLeap,
  isEqualDates,
  isEqualMonths,
  isEqual,
  addDays,
  addMonths,
  addYears,
  setLocale,
  getCurrentLocale,
  lastMonthDate,
  parse,
  utc,
  isDateInRange,
  dayOfYear
}
