class Log_Parser
	def mean(array)
		meanG=0
		array.each do |a|
			meanG=meanG+a
		end
		return meanG/array.size
	end

	def median(array)
		sorted = array.sort
		len = sorted.length
		return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2
	end

	def mode(array)
		freq = getFreq(array)
		return array.max_by { |v| freq[v] }
	end

	def getFreq(array)
		return array.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
	end

	def responseTime(line)
		connect= line[/\sconnect=[0-9]+ms\s/i].scan(/\sconnect=(\d+)ms\s/).pop.pop.to_i
		service= line[/\sservice=[0-9]+ms\s/i].scan(/\sservice=(\d+)ms\s/).pop.pop.to_i
		response=connect+service
		return response
	end

	def sortHash(hash)
  		return hash.sort_by {|_key, value| value}
	end

	def getDyno(line)
		return line[/\sdyno=web.(\d+)\s/]
	end
end

countPending=0
countGetMessages=0
countGetFriendsProgress=0
countGetFriendsScore=0
countGetUsers=0
countPostUsers=0
responsePending=[]
responseGetMessages=[]
responseGetFriendsProgress=[]
responseGetFriendsScore=[]
responseGetUsers=[]
responsePostUsers=[]
examplePending=""
exampleGetMessages=""
exampleGetFriendsProgress=""
exampleGetFriendsScore=""
exampleGetUsers=""
examplePostUsers=""
dynoPending=[]
dynoGetMessages=[]
dynoGetFriendsProgress=[]
dynoGetFriendsScore=[]
dynoGetUsers=[]
dynoPostUsers=[]
lp=Log_Parser.new()

File.foreach('sample.log') do |line|
	if line=~ /method=GET path=\/api\/users\/[0-9]+\/count_pending_messages\s/i
		responsePending<<lp.responseTime(line)
		dynoPending<<lp.getDyno(line)
		countPending=countPending+1
		if countPending==1
			examplePending="GET "+line[/\/api\/users\/[0-9]+\/count_pending_messages\s/]
		end
  	end
  	if line=~ /method=GET path=\/api\/users\/[0-9]+\/get_messages\s/i
		responseGetMessages<<lp.responseTime(line)
		dynoGetMessages<<lp.getDyno(line)
  		countGetMessages=countGetMessages+1
  		if countGetMessages==1
			exampleGetMessages="GET "+line[/\/api\/users\/[0-9]+\/get_messages\s/]
		end
  	end
  	if line=~ /method=GET path=\/api\/users\/[0-9]+\/get_friends_progress\s/i
		responseGetFriendsProgress<<lp.responseTime(line)
		dynoGetFriendsProgress<<lp.getDyno(line)
  		countGetFriendsProgress=countGetFriendsProgress+1
  		if countGetFriendsProgress==1
			exampleGetFriendsProgress="GET "+line[/\/api\/users\/[0-9]+\/get_friends_progress\s/]
		end
  	end
  	if line=~ /method=GET path=\/api\/users\/[0-9]+\/get_friends_score\s/i
		responseGetFriendsScore<<lp.responseTime(line) 	
		dynoGetFriendsScore<<lp.getDyno(line)		
  		countGetFriendsScore=countGetFriendsScore+1
  		if countGetFriendsScore==1
			exampleGetFriendsScore="GET "+line[/\/api\/users\/[0-9]+\/get_friends_score\s/]
		end
  	end
	if line=~ /method=POST path=\/api\/users\/[0-9]+\s/i
		responsePostUsers<<lp.responseTime(line)
		dynoPostUsers<<lp.getDyno(line)
  		countPostUsers=countPostUsers+1
  		if countPostUsers==1
			examplePostUsers="POST "+line[/\/api\/users\/[0-9]+\s/]
		end
  	end
  	if line=~ /method=GET path=\/api\/users\/[0-9]+\s/i
		responseGetUsers<<lp.responseTime(line)
		dynoGetUsers<<lp.getDyno(line)
		countGetUsers=countGetUsers+1
		if countGetUsers==1
			exampleGetUsers="GET "+line[/\/api\/users\/[0-9]+\s/]
		end
	end
end


puts "GET /api/users/{user_id}/count_pending_messages was called #{countPending} times"
if (countPending!=0)
	puts "Mean: #{lp.mean(responsePending)}"
	puts "Median: #{lp.median(responsePending)}"
	puts "Mode: #{lp.mode(responsePending)}"
	puts "Entry Example: #{examplePending}"
	puts "Dyno that responded the most#{lp.mode(dynoPending)}with frequency #{lp.getFreq(dynoPending)[lp.mode(dynoPending)]}"
else
	puts "Mean: 0"
	puts "Median: 0"
	puts "Mode: 0"
	puts "Entry Example: None"
	puts "Dyno: None"
end

puts "!!!!!!!!!!!!!!!!!"
puts "GET /api/users/{user_id}/get_messages was called #{countGetMessages} times"
if (countGetMessages!=0)
	puts "Mean: #{lp.mean(responseGetMessages)}"
	puts "Median: #{lp.median(responseGetMessages)}"
	puts "Mode: #{lp.mode(responseGetMessages)}"	
	puts "Entry Example: #{exampleGetMessages}"
	puts "Dyno that responded the most#{lp.mode(dynoGetMessages)}with frequency #{lp.getFreq(dynoGetMessages)[lp.mode(dynoGetMessages)]}"
else
	puts "Mean: 0"
	puts "Median: 0"
	puts "Mode: 0"
	puts "Entry Example: None"
	puts "Dyno: None"
end

puts "!!!!!!!!!!!!!!!!!"
puts "GET /api/users/{user_id}/get_friends_progress was called #{countGetFriendsProgress} times"
if (countGetFriendsProgress!=0)
	puts "Mean: #{lp.mean(responseGetFriendsProgress)}"
	puts "Median: #{lp.median(responseGetFriendsProgress)}"
	puts "Mode: #{lp.mode(responseGetFriendsProgress)}"	
	puts "Entry Example: #{exampleGetFriendsProgress}"
	puts "Dyno that responded the most#{lp.mode(dynoGetFriendsProgress)}with frequency #{lp.getFreq(dynoGetFriendsProgress)[lp.mode(dynoGetFriendsProgress)]}"
else
	puts "Mean: 0"
	puts "Median: 0"
	puts "Mode: 0"
	puts "Entry Example: None"
	puts "Dyno: None"
end

puts "!!!!!!!!!!!!!!!!!"
puts "GET /api/users/{user_id}/get_friends_score was called #{countGetFriendsScore} times"
if (countGetFriendsScore!=0)
	puts "Mean: #{lp.mean(responseGetFriendsScore)}"
	puts "Median: #{lp.median(responseGetFriendsScore)}"
	puts "Mode: #{lp.mode(responseGetFriendsScore)}"	
	puts "Entry Example: #{exampleGetFriendsScore}"
	puts "Dyno that responded the most#{lp.mode(dynoGetFriendsScore)}with frequency #{lp.getFreq(dynoGetFriendsScore)[lp.mode(dynoGetFriendsScore)]}"
else
	puts "Mean: 0"
	puts "Median: 0"
	puts "Mode: 0"
	puts "Entry Example: None"
	puts "Dyno: None"
end

puts "!!!!!!!!!!!!!!!!!"
puts "GET /api/users/{user_id} was called #{countGetUsers} times"
if (countGetUsers!=0)
	puts "Mean: #{lp.mean(responseGetUsers)}"
	puts "Median: #{lp.median(responseGetUsers)}"
	puts "Mode: #{lp.mode(responseGetUsers)}"	
	puts "Entry Example: #{exampleGetUsers}"
	puts "Dyno that responded the most#{lp.mode(dynoGetUsers)}with frequency #{lp.getFreq(dynoGetUsers)[lp.mode(dynoGetUsers)]}"
else
	puts "Mean: 0"
	puts "Median: 0"
	puts "Mode: 0"
	puts "Entry Example: None"
	puts "Dyno: None"
end

puts "!!!!!!!!!!!!!!!!!"
puts "POST /api/users/{user_id} was called #{countPostUsers} times"
if (countPostUsers!=0)
	puts "Mean: #{lp.mean(responsePostUsers)}"
	puts "Median: #{lp.median(responsePostUsers)}"
	puts "Mode: #{lp.mode(responsePostUsers)}"	
	puts "Entry Example: #{examplePostUsers}"
	puts "Dyno that responded the most#{lp.mode(dynoPostUsers)}with frequency #{lp.getFreq(dynoPostUsers)[lp.mode(dynoPostUsers)]}"
else
	puts "Mean: 0"
	puts "Median: 0"
	puts "Mode: 0"
	puts "Entry Example: None"
	puts "Dyno: None"
end

