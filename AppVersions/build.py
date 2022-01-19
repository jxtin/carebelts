import subprocess
import multiprocessing
import shutil, os

def multiprocessing_func(num):
    subprocess.call(f"cd v{num} && flutter build apk",shell=True)
    os.rename(f"v{num}\\build\\app\outputs\\flutter-apk\\app-release.apk",f"v{num}\\build\\app\outputs\\flutter-apk\\v{num}.apk")
    shutil.copy(f"v{num}\\build\\app\outputs\\flutter-apk\\v{num}.apk","apps")
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