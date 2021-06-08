#!/usr/bin/env ruby

require 'date'
require 'optparse'
opt = OptionParser.new

params = {}

opt.on('-y [VAL]') { |v| params[:y] = v }
opt.on('-m [VAL]') { |v| params[:m] = v }

opt.parse!(ARGV)

day_today = Date.today

if params[:y].to_i <= 2100 && params[:y].to_i >= 1970 #オプションが1970年から2100年の間ならその年、それ以外は今年を代入
  corrected_year= params[:y].to_i
else
  corrected_year= day_today .year.to_i
end

if params[:m].to_i <= 12 && params[:m].to_i >= 1 #オプションが1月から12月ならその月、それ以外は今月を代入
  corrected_month = params[:m].to_i
else
  corrected_month = day_today .month.to_i
end

day_last = Date.new(corrected_year, corrected_month, -1).day #月の日数

puts "#{corrected_month}月 #{corrected_year}".center(20) #何年の何月か表示
puts "日 月 火 水 木 金 土"

days = [] #日付を格納

week = Date.new(corrected_year.to_i, corrected_month.to_i, 1).wday #1日の曜日を判定

week.times do #1日の曜日によって何個最初に空白を入れるか決める
  days.push("   ")
end

(1..day_last).each do |day|
  if day < 10            #1桁の数字は右寄せ
    days.push(" #{day} ")
  else
    days.push("#{day} ")
  end

  if days.size % 7 == 0 #7日を一区切りにして改行して表示
    puts days.join
    days = []
  end
  
end

puts days.join #最終週を表示
