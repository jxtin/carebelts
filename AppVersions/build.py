import subprocess
import multiprocessing

def multiprocessing_func(num):
    # subprocess.call(f"cd v{num} && flutter build apk",shell=True) 
    subprocess.call(f'cd v{num} && flutter clean', shell=True)

def main():
    processes = []
    for i in range(0,5):
        p = multiprocessing.Process(target=multiprocessing_func, args=(i,))
        processes.append(p)
        p.start()
        
    for process in processes:
        process.join()

if __name__ == "__main__":
    main()