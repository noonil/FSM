//
//  BusinessOwnerView.m
//  Ericsson
//
//  Created by xuming on 16/1/13.
//  Copyright (c) 2016年 范传斌. All rights reserved.
//

#import "BusinessOwnerView.h"


#define mmTitleLabWidth 90 //title的宽度


#define mmEdigeMargin 10 //上下左右边间隙
#define mmRowMargin 5 //行间隙
#define mmRow 8//有多少行
#define mmTitleContentMargin 1//标题和内容之间的间隙



@interface BusinessOwnerView ()<UIGestureRecognizerDelegate>{
    int mmLabHeight;//title 和 content 的高度。
    int mmContentWidth;//content的宽度
}
@property (nonatomic, strong) NSMutableArray *titleLabArray;
@property (nonatomic, strong) NSMutableArray *contentLabArray;
@property (nonatomic,strong)BusinessOwnerView *businessOwnerView;

@end

@implementation BusinessOwnerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        
        [self addChildView];
        
        [self setOthers];
        
        self.backgroundColor=[UIColor grayColor];
        
    }
    
    return self;

}



-(void)setOthers{
    //content的宽度
    mmContentWidth=self.frame.size.width-mmEdigeMargin*2-mmTitleLabWidth-mmTitleContentMargin;
    
    //lab的高度
    mmLabHeight=( self.frame.size.height-mmEdigeMargin*2-mmRowMargin*(mmRow-1))/(mmRow);
    
    [self addGesture];
}

-(void)addGesture{
    UITapGestureRecognizer* recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelf)];
    recognizer.delegate=self;
    [self addGestureRecognizer:recognizer];
}

//隐藏自己
-(void)hideSelf{
    if ([self.delegate respondsToSelector:@selector(BusinessOwnerViewTap)]) {
        [self.delegate BusinessOwnerViewTap];
    }
}


-(void)addChildView{
    
    for (int i=1; i<=mmRow; i++) {
        UILabel *titleLab=[self getTitleLabel];
        titleLab.text=@"业主联系方式:";
        [self.titleLabArray addObject:titleLab];
        [self addSubview: titleLab];

        
        UILabel *contentLabel=[self getContentLabel];
        [self.contentLabArray addObject:contentLabel];
        
        if (i==5) {
            UITapGestureRecognizer* recognizer;
            recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(call)];
            recognizer.delegate=self;
            [contentLabel addGestureRecognizer:recognizer];
            contentLabel.backgroundColor=[UIColor purpleColor];
            contentLabel. userInteractionEnabled=YES;
            

        }
        
        [self addSubview:contentLabel];

    }
 

}

-(void)call{

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://15380822424"]];

}

-(UILabel *)getTitleLabel{
    
    UILabel *titleLab=[[UILabel alloc]init];
    titleLab.font=[UIFont systemFontOfSize:15];
    titleLab.textColor=[UIColor blueColor];
    titleLab.backgroundColor=[UIColor yellowColor];
    
    return titleLab;
}

-(UILabel *)getContentLabel{
    UILabel *contentLabel=[[UILabel alloc]init];
    contentLabel.font=[UIFont systemFontOfSize:15];
    contentLabel.textColor=[UIColor blueColor];
    contentLabel.backgroundColor=[UIColor greenColor];
    
    return contentLabel;
}




-(void)layoutSubviews{

    [super layoutSubviews];
    
    
    for (int i=0; i<mmRow; i++) {
        UILabel *titleLabel=_titleLabArray[i];
        float y=mmEdigeMargin+ mmLabHeight*i+mmRowMargin*i;
        titleLabel.frame=CGRectMake(mmEdigeMargin,y,mmTitleLabWidth,mmLabHeight );
        titleLabel.font=[UIFont systemFontOfSize:13];
    }
    
    
    for (int i=0; i<mmRow; i++) {
        UILabel *contentLabel=_contentLabArray[i];
        float y=mmEdigeMargin+ mmLabHeight*i+mmRowMargin*i;
        contentLabel.frame=CGRectMake(mmEdigeMargin+mmTitleLabWidth+mmTitleContentMargin,y,mmContentWidth,mmLabHeight );
        
//        if (i==4) {
//            _callButton.frame=contentLabel.bounds;
//        }
    }
    
//    UILabel *titleLabel=_titleLabArray[0];
//    titleLabel.frame=CGRectMake(mmEdigeMargin,mmEdigeMargin,mmTitleLabWidth,mmEdigeMargin );
//    
//    UILabel *titleLabel1=_titleLabArray[1];
//    titleLabel1.frame=CGRectMake(mmEdigeMargin,CGRectGetMaxY(titleLabel.frame)+mmRowMargin,mmTitleLabWidth,mmLabHeight );
//    
//    UILabel *titleLabel2=_titleLabArray[2];
//    titleLabel2.frame=CGRectMake(mmEdigeMargin,CGRectGetMaxY(titleLabel1.frame)+mmRowMargin,mmTitleLabWidth,mmLabHeight );
//    
//    
    
}

#pragma mark - get/set
-(NSMutableArray *)titleLabArray{
    
    if (_titleLabArray==nil) {
        _titleLabArray=[[NSMutableArray alloc]init];
    }
    
    return _titleLabArray;

}

-(NSMutableArray *)contentLabArray{
    
    if (_contentLabArray==nil) {
        _contentLabArray=[[NSMutableArray alloc]init];
    }
    
    return _contentLabArray;


}

@end
