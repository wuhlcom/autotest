#encoding:utf-8
class Calculator
  def push(n) #记数
    @args ||= [] #初始化空数组
    @args << n
  end

  def sum() #返回所有数字和
    sum = 0
    @args.each do |i|
      sum += i
    end
    @result = sum
  end

  def result
    @result
  end
end

# p Calculator.new
Given /^我有一个计算器$/ do
  @c = Calculator.new
end

Given /^我向计算器输入(\d+)$/ do |num|
  @c.push(num.to_i)
end

When /^我点击累加$/ do
  @c.sum
end

Then /^我应该看到结果(\d+)$/ do |result|
  expect(@c.result).to eq(result.to_i)
  # specify {expect @c.result.to eq(result.to_i)}
  # @c.result.should==(result.to_i)
end