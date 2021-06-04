#!/usr/bin/env ruby

require 'date'
require 'optparse'
opt = OptionParser.new

params = {}

opt.on('-y [VAL]') { |v| params[:y] = v }
opt.on('-m [VAL]') { |v| params[:m] = v }

opt.parse!(ARGV)

d = Date.today #今日の日付

if params[:y].to_i < 3000 && params[:y].to_i > 1900 #オプションが1900年から3000年の間ならその年、それ以外は今年を代入
  year_collect = params[:y].to_i
else
  year_collect = d.year.to_i
end

if params[:m].to_i <= 12 && params[:m].to_i >= 1 #オプションが1月から12月ならその月、それ以外は今月を代入
  month_collect = params[:m].to_i
else
  month_collect = d.month.to_i
end

if year_collect  % 4 == 0 && month_collect == 2 #うるう年の2月は何日まであるか
  nanniti = 29
elsif month_collect == 2
  nanniti = 28
elsif month_collect == 4|| month_collect == 6|| month_collect == 9 || month_collect == 11
  nanniti = 30
else
  nanniti = 31
end 

puts "#{month_collect}月 #{year_collect}".center(20) #何年の何月か表示
puts "日 月 火 水 木 金 土"

days = [] #日付を格納

week = Date.new(year_collect.to_i, month_collect.to_i, 1).wday #1日の曜日を判定

week.times do #1日の曜日によって何個最初に空白を入れるか決める
  days.push("   ")
end

(1..nanniti).each do |day|
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
