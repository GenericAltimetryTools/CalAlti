from queue import Queue
from threading import Thread
import cdsapi
from time import time
import datetime
import os


def downloadonefile(riqi):
    ts = time()
    filename = "./data/era5.pl." + riqi + ".nc"
    if (os.path.isfile(filename)):  # 如果存在文件名则返回
        print("ok", filename)
    else:
        print(filename)
        c = cdsapi.Client()
        c.retrieve(
            'reanalysis-era5-pressure-levels',
            {
                'product_type': 'reanalysis',
                'format': 'netcdf',
                'variable': [
                    'geopotential', 'specific_humidity', 'temperature',
                ],
                'pressure_level': [
                    '200',
                    '225', '250', '300',
                    '350', '400', '450',
                    '500', '550', '600',
                    '650', '700', '750',
                    '775', '800', '825',
                    '850', '875', '900',
                    '925', '950', '975',
                    '1000',
                ],
                'year': riqi[0:4],
                'month': riqi[-4:-2],
                'day': riqi[-2:],
                'time': [
                    '00:00', '03:00', '06:00',
                    '09:00', '12:00', '15:00',
                    '18:00', '21:00',
                ],
                # North China
                # 'area': [
                #     41.5, 116.5, 34,
                #     125.5,
                # ],
                # Middle China
                'area': [
                    33, 116, 22,
                    123.5,
                ],
                # South China
                # 'area': [
                #     23.5, 107, 15.5,
                #     116.5,
                # ],
            },
            filename)


# 下载脚本
class DownloadWorker(Thread):
    def __init__(self, queue):
        Thread.__init__(self)
        self.queue = queue

    def run(self):
        while True:
            # 从队列中获取任务并扩展tuple
            riqi = self.queue.get()
            downloadonefile(riqi)
            self.queue.task_done()


# 主程序
def main():
    # 起始时间
    ts = time()

    # 起始日期
    begin = datetime.date(2015, 1, 1)
    end = datetime.date(2015, 3, 31)
    d = begin
    delta = datetime.timedelta(days=1)

    # 建立下载日期序列
    links = []
    while d <= end:
        riqi = d.strftime("%Y%m%d")
        links.append(str(riqi))
        d += delta

    # 创建一个主进程与工作进程通信
    queue = Queue()

    # 20191119更新# 新的请求规则 https://cds.climate.copernicus.eu/live/limits
    # 注意，每个用户同时最多接受4个request https://cds.climate.copernicus.eu/vision
    # 创建四个工作线程
    for x in range(4):
        worker = DownloadWorker(queue)
        # 将daemon设置为True将会使主线程退出，即使所有worker都阻塞了
        worker.daemon = True
        worker.start()

    # 将任务以tuple的形式放入队列中
    for link in links:
        queue.put((link))

    # 让主线程等待队列完成所有的任务
    queue.join()
    print('Took {}'.format(time() - ts))


if __name__ == '__main__':
    main()

