TEST="${1:-01}"

bash ./controller/benchmark_R.sh ${TEST}
bash ./controller/benchmark_python.sh ${TEST}
bash ./controller/benchmark_julia.sh ${TEST}
bash ./controller/benchmark_julia_multithreading.sh ${TEST}