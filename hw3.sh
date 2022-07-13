#!/bin/bash
# Bash script to calculates the MAX, MIN, MEDIAN and MEAN of the word frequencies in the
# file the  https://www.gutenberg.org/files/58785/58785-0.txt

if [ $# -ne 1 ]
   then
       echo "Please provide a txt file url"
       echo "usage ./calculate_basic_stats.sh  url"
       #exit with error
       exit 1
fi   

echo  "############### Statistics for file  ############### "

# Q1(.5 point) write  positional parameter after echo to print its value. It is the file url used by curl command.

echo $1 


# sort based on multiple columns
#Q2(2= 1+1 for right sorting of each columns). Write last sort command options so that first column(frequencies) is
#sorted via numerical values and
#second column is sorted by reverse alphabetical order

#Some caching, remove sorted_words.tmp to disable 
if [ -f sorted_words.tmp ];
then
	sorted_words="$(cat sorted_words.tmp)";
else
	sorted_words=`curl -s $1|tr [A-Z] [a-z]|grep -oE "\w+"|sort|uniq -c|sort  `
	#odd number sorted_words=`curl -s $1|tr [A-Z] [a-z]|grep -oE "\w+"|sort|uniq -c|sort|tail -n 10979  `
	echo -n "$sorted_words" > sorted_words.tmp
fi


total_uniq_words=`echo "$sorted_words"|wc -l`
echo "Total number of words = $total_uniq_words"


#Q3(1=.5+.5 points ) Complete the code in the following echo statements to calculate the  Min and Max frequency with respective word
#Hint:  Use sorted_words variable, head, tail and command susbtitution

echo "Min frequency and word   $(echo -n "$sorted_words" | head -n 1)"
# Alternative if all words with the min frequency are desired:
#echo "Min frequency and word(s) $(echo -n "$sorted_words" | head -n 1 | awk '{ print $1 }')  $(echo -n "$sorted_words" | grep "^[ ]*$(echo -n "$sorted_words" | head -n 1 | awk '{ print $1 }') " | awk '{ print $2 }' | xargs | sed 's/ /,/g'))"
echo "Max frequency and word  $(echo -n "$sorted_words" | tail -n 1)"



#Median calculation

#Q4(2=1(taking care of even number of frequencies)+1 points(right value of median)). Using sorted_words,
#write code for median frequency value calculation. Print the value of the median with an echo statement, stating
# it is a median value.
#Code must check even or odd  number of unique words. For even case median is the mean of middle two values,
#for the odd case, it is middle value in sorted items.
tot_words=$(echo -n "$sorted_words" | wc -l); 
if [ $(expr $tot_words % 2) -eq 0 ]; 
then
	echo -n "Median frequency value is "
	echo "($(echo -n "$sorted_words" | head -n $(expr $tot_words / 2 + 1) | tail -n 1 | awk '{ print $1 }') + $(echo -n "$sorted_words" | head -n $(expr $tot_words / 2) | tail -n 1 | awk '{ print $1 }'))/2" | bc -l;
else
	echo -n "Median frequency value is "
	echo -n "$sorted_words" | head -n $(expr $tot_words / 2 + 1) | tail -n 1 | awk '{ print $1 }';
fi





# Mean value calculation
#Q5(1 point) Using for loop, write code to update count variable: total number of unique words
#Q6(1 point) Using for loop, write code to update total_freq variable : sum of frequencies
total_freq=0
for freq in $(echo -n "$sorted_words" | awk '{ print $1 }');
do
	total_freq=$(($total_freq + $freq))
done
count=0
for word in $(echo -n "$sorted_words" | awk '{ print $2 }');
do
	count=$(($count + 1))
done


#Q7(1 point) Write code to calculate mean frequency value based on total_freq and count
mean=$(( $total_freq/$count))



echo "Sum of frequencies = $total_freq"
echo "Total unique words = $count"
echo "Mean frequency using integer arithmetics = $mean"

#Q8(1 point) Using bc -l command, calculate mean value.
# Write your code after = 
echo "Mean frequency using floating point arithemetics =  $(echo "$total_freq/$count" | bc -l )"



# Q9 (1 point) Complete lazy_commit bash function(look for how to write bash functions) to add, commit and push to the remote master.
# In the command prompt, this function is used as
#
# lazygit file_1 file_2 ... file_n commit_message
#
# This bash function must take files name and commit message as positional parameters
# and perform followling git function
#
# git add file_1 file_2 .. file_n
# git commit -m commit_message
# git push origin master

#
# Side: In the Linux if we put this function in .bashrc hidden file in
# the user home directory(type cd ~ to go to the home directory) and source .bashrc after adding this function,
# lazy_commit should be available in the command prompt.
# One can type lazy_commit file1 file2 ... filen  commit_message
# and file will be added , commited and pushed to remote master using one lazy_commit command.
function lazy_commit() {
	count=1
	args=""
	for var in "$@"
	do
		if [ $count == $# ];
		then
			git add "${args}"
			git commit -m "${var}"
			git push origin master 
		else
			if [ $count == 1 ];
			then
				args=$var
			else
				args="$args $var"
			fi
		fi
		count=$(($count + 1))
	done
}
#lazy_commit one two three "zippity bippity"
