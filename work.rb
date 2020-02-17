require 'json'

def report_user(user, sessions)

  browsers, times, dates = sessions.transpose

  File.write("result.json",
             "#{@user_count > 0 ? ',' : ''}\"#{user}\":{\"sessionsCount\":#{sessions.size},\"totalTime\":\"#{times.sum} min.\",\"longestSession\":\"#{times.max} min.\",\"browsers\":\"#{browsers.sort.join(', ')}\",\"usedIE\":#{browsers.any?{ |b| b.start_with?('INTERNET EXPLORER') }},\"alwaysUsedChrome\":#{browsers.all?{ |b| b.start_with?('CHROME') }},\"dates\":#{dates.sort.reverse}}",
             mode: "a")
  @user_count += 1
  @session_count += sessions.size
  @unique_browsers += browsers
  @unique_browsers.uniq!
end

def work(source_data_file = 'data.txt', disable_gc = false)

  GC.disable if disable_gc

  @session_count = 0
  @user_count = 0
  @unique_browsers = []
  File.write("result.json", '{"usersStats":{') #, mode: "a"

  File.open(source_data_file, 'r') do |f|
    user = ''
    sessions = []
    while line = f.gets # line = lines[i]; i += 1; line
      if line[0..3] == 'user'
        report_user(user, sessions) unless sessions.empty?
        user = line.split(',')[2..3].join(' ')
        sessions = []
      else
        browser, time, date = *line.split(',')[3..5]
        sessions << [browser.upcase, time.to_i, date.strip]
      end
    end
    report_user(user, sessions) unless sessions.empty?
  end
  File.write("result.json", '},', mode: "a")

  report = {}

  report[:totalUsers] = @user_count

  report['uniqueBrowsersCount'] = @unique_browsers.size

  report['totalSessions'] = @session_count

  report['allBrowsers'] = @unique_browsers.sort.join(',')

  File.write('result.json', "#{report.to_json[1..-1]}\n", mode: 'a')
  puts "MEMORY USAGE: %d MB" % (`ps -o rss= -p #{Process.pid}`.to_i/1024)
end

time1 = Time.now.to_i

ARGV[0] ? work(ARGV[0]) : work

puts "Work time: %d s" % (Time.now.to_i - time1.to_i)
