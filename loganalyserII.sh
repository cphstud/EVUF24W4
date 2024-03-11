#!/bin/bash  

ts=$( date +%Y-%m-%d_%H:%M:%S )
filename=$ts"_analyse.txt"
logfilename=$ts"_log.txt"
logfiles="/var/log/apache2/access*"
logfilescp="/home/ubuntu/loganalyse/logs"
logfilescpold="/home/ubuntu/loganalyse/logs/old"
rapportdir="/home/ubuntu/loganalyse/rapport"

echo "starting ..." > "$rapportdir/$logfilename" 
#copy processed files to old local dir
cp "$logfilescp"/acc* $logfilescpold >> "$rapportdir/$logfilename" 2>&1
rm "$logfilescp"/acc* >> "$rapportdir/$logfilename" 2>&1

#copy files to local dir
cp $logfiles $logfilescp >> "$rapportdir/$logfilename" 2>&1
gzip -d "$logfilescp"/acc* >> "$rapportdir/$logfilename" 2>&1


echo "starting ..." > "$rapportdir/$filename" 
for i in {1..10}
do
	cut -d ' ' -f$i /home/ubuntu/loganalyse/logs/acc* | sort | uniq -c | sort -nr >> "$rapportdir/$filename"
	echo " " >> "$rapportdir/$filename" 
done



exit -1

echo "starting ..." > "$rapportdir/$filename" 
echo "METHOD " >> "$rapportdir/$filename" 
cut -d ' ' -f6 /home/ubuntu/loganalyse/logs/acc* | sort | uniq -c | sort -nr >> "$rapportdir/$filename"
echo " " >> "$rapportdir/$filename" 
echo "IP " >> "$rapportdir/$filename" 
cut -d ' ' -f1  /home/ubuntu/loganalyse/logs/acc* | sort | uniq -c | sort -nr | head >>  "$rapportdir/$filename"
echo " " >> "$rapportdir/$filename" 
echo "ERRORCODE " >> "$rapportdir/$filename" 
cut -d ' ' -f9 /home/ubuntu/loganalyse/logs/acc* | sort | uniq -c | sort -nr >> "$rapportdir/$filename"
echo " " >> "$rapportdir/$filename" 
echo "stopping ..." >> "$rapportdir/$filename" 
