bash controller/benchmark_all.sh "01"
for TEST in {01..06}; do bash controller/benchmark_all.sh "$TEST"; done
python3 generate_dashboard.py
open -a "Firefox" dashboard/index.html