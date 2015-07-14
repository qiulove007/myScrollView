//
//  ViewController.m
//  myScrollView
//
//  Created by PC－qiu on 15/7/13.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import "ViewController.h"
#import "HWUIView+Extension.h"
#define imageViewCount 5;//图片个数

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIPageControl* page;
@property(nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic,assign) int displayPageNum;//当前显示的图片位置，从0开始
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建一个scrollView显示所有的新特性图片
    [self setupScrollView];
    //2.创建一个PageView显示当前显示的图片位置
    [self setupPageView];
    //设置播放图片的个数为第0个
    self.displayPageNum=0;
    //每两秒钟执行一次nextPage函数。
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
}
/**
 *  初始化显示图片的UIScrollView
 */
-(void)setupScrollView
{
    //初始化UIScrollView并为其设置frame，并将其添加到ViewController的视图中去
    UIScrollView* scrollView=[[UIScrollView alloc]init];
    scrollView.frame=CGRectMake(0, 20, self.view.bounds.size.width, 240);
    [self.view addSubview:scrollView];
    
    //一个ImageView375*240；
    CGFloat scrollW=scrollView.width;
    CGFloat scrollH=scrollView.height;
    //设置轮换图片的个数到num变量中
    int num=imageViewCount;
    for(int i=0;i<num;i++)
    {//循环添加UIImageView
        //初始化图片组件，并将图片添加到scroll的子视图中去
        UIImageView* imageView=[[UIImageView alloc]init];
        imageView.frame=CGRectMake(i*scrollW, 0, scrollW, scrollH);
        //下面2行是设置图片路径的，我的图片名是（cmm1,cmm2,cmm3,cmm4,cmm5),请读者自行设置
        NSString* path=[NSString stringWithFormat:@"cmm%d",i+1];
        imageView.image=[UIImage imageNamed:path];
        [scrollView addSubview:imageView];
    }
    
    //contentSize设置scrollView可以进行拖动的范围
    scrollView.contentSize=CGSizeMake(num*scrollW, 0);
    //取出弹簧效果，不过看到超出部分的内容
    scrollView.bounces=NO;
    //进行拖动的时候自动分页，为NO的时候就是拖到哪里就是哪里
    scrollView.pagingEnabled=YES;
    //设置delegate，因为要使用scrollViewDidScroll这个内容
    scrollView.delegate=self;
    //保存起来，其他地方还要用。
    self.scrollView=scrollView;
}

/**
 *  初始化显示当前图片位置的UIPageView
 */
-(void)setupPageView
{
    //设置轮换图片的个数到num变量中
    int num=imageViewCount;
    //一个ImageView375*240；
    CGFloat scrollW=self.scrollView.width;
    CGFloat scrollH=self.scrollView.height;
    //添加PageControl进行分页
    UIPageControl* page=[[UIPageControl alloc]init];
    //设置一共要分几页
    page.numberOfPages=num;
    //设置宽高，中心点X，中心点Y
    page.width=20*num;
    page.height=50;
    page.centerX=scrollW*0.5;
    page.centerY=scrollH-5;
    //当前正在访问的圆点的颜色
    page.currentPageIndicatorTintColor=[UIColor orangeColor];
    //设置未显示的page的圆点颜色
    page.pageIndicatorTintColor = [UIColor grayColor];
    //禁止通过圆点的点击来访问对应页面
    page.userInteractionEnabled=NO;
    //保存起来，其他地方还要使用
    self.page=page;
    
    //添加进入视图
    [self.view addSubview:page];
}

/**
 *  调用该函数，将会显示下一张图片
 *
 *  @param timer timer
 */
-(void)nextPage:(NSTimer*)timer
{
    //得到图片总数
    int num=imageViewCount;
    if(self.displayPageNum<num-1)//如果不是最后一个
    {
        self.displayPageNum++;//当前图片显示数字+1
        self.page.currentPage = self.displayPageNum;//切换PageView的当前显示
        //滚动scrollView到正确的图片位置
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*self.displayPageNum, 0) animated:YES];
    }
    else if(self.displayPageNum==num-1)//如果已经是最后一个
    {
        //PageView和ScrollView都滚到第一个去。
        self.displayPageNum=0;
        self.page.currentPage = 0;
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
/**
 *  当UIScrollView发生滚动时触发
 *
 *  @param scrollView 正在滚动的scrollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //scrollView的contentOffset可以得到滚动的位置信息，x,y值
    self.page.currentPage=round((scrollView.contentOffset.x / scrollView.width));
    //保存滚动的位置
    self.displayPageNum =self.page.currentPage;
}

@end
