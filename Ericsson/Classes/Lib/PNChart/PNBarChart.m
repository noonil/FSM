//
//  PNBarChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNBarChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"


@interface PNBarChart () {
    NSMutableArray *_xChartLabels;
    NSMutableArray *_yChartLabels;
}

- (UIColor *)barColorAtIndex:(NSUInteger)index;

@end

@implementation PNBarChart

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self setupDefaultValues];
    }

    return self;
}

- (void)setupDefaultValues
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds   = YES;
    _showLabel           = YES;
    _barBackgroundColor  = [UIColor clearColor];//PNLightGrey;
    _labelTextColor      = [UIColor blackColor];
    _labelFont           = [UIFont systemFontOfSize:11.0f];
    _xChartLabels        = [NSMutableArray array];
    _yChartLabels        = [NSMutableArray array];
    _bars                = [NSMutableArray array];

    _barRadius           = 2.0;
    _showChartBorder     = NO;
    _rotateForXAxisText  = false;
    
    _xLabelSkip          = 1;
    _xLabelSum           = 7;
    _labelMarginTop      = 0;
    _chartMargin         = 15.0;
    _chartRightMargin    = 15.0;
    _chartLeftMargin     = 5;
    _yLabelWidth         = 40;
    

}


/*
 许明的y轴
 */
- (void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    

    
    
    _yLabelSum=yValues.count;

    
    if (_yChartLabels) {
        [self viewCleanupForCollection:_yChartLabels];
    }else{
        _yLabels = [NSMutableArray new];
    }
    
    if (_showLabel) {
        //Add y labels
        
        float yLabelSectionHeight = (self.frame.size.height - _chartMargin*2  - xLabelHeight) / _yLabelSum;
        
        for (int index = 0; index < _yLabelSum; index++) {
            
            PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(_chartLeftMargin,
                                                                                  (_chartMargin)+yLabelSectionHeight * index ,
                                                                                  _yLabelWidth,
                                                                                  yLabelHeight)];
            label.font = _labelFont;
            label.textColor = _labelTextColor;
            [label setTextAlignment:NSTextAlignmentLeft];
            label.text = ((NSString *)[yValues objectAtIndex:index]);
            label.backgroundColor=[UIColor clearColor];
            
            [_yChartLabels addObject:label];
            [self addSubview:label];
            

            
        }
    }
}


/*
 许明的x轴
 
 */

-(void)setBarLongArray:(NSArray *)barLongArray
{
    _barLongArray = barLongArray;
    
    if (_xMaxValue) {
        _xValueMax = _xMaxValue;
    } else {
        [self getBarLongMax:barLongArray];
    }
    
    
    if (_xChartLabels) {
        [self viewCleanupForCollection:_xChartLabels];
    }else{
        _xChartLabels = [NSMutableArray new];
    }
    
    if (_showLabel) {
        _xLabelWidth = (self.frame.size.width - _yLabelWidth-_chartRightMargin-_chartLeftMargin-barRightLabelWidth) / _xLabelSum;
        
        int labelAddCount = 0;
        for (int index = 0; index < _xLabelSum; index++) {
            labelAddCount += 1;
            
            if (labelAddCount == _xLabelSkip) {
                float mm=(float)_xValueMax * ( (index+1) / (float)_xLabelSum );
                NSString *labelText = _xLabelFormatter(mm);
                
                
                PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0, 0, _xLabelWidth, xLabelHeight)];
                label.font = _labelFont;
                label.textColor = _labelTextColor;
                [label setTextAlignment:NSTextAlignmentCenter];
                label.text = labelText;
                label.backgroundColor=[UIColor clearColor];
                label.textAlignment=UITextAlignmentRight;
                
                
                //[label sizeToFit];
                CGFloat labelXPosition;
                if (_rotateForXAxisText){
                    //这个没执行
                    label.transform = CGAffineTransformMakeRotation(M_PI / 4);
                    labelXPosition = (index * _xLabelWidth + _chartLeftMargin + _yLabelWidth + _xLabelWidth /1.5);
                }
                else{
                    labelXPosition = (index * _xLabelWidth + _chartLeftMargin + _yLabelWidth + _xLabelWidth /2.0 );
                }
                label.center = CGPointMake(labelXPosition,
                                           self.frame.size.height - xLabelHeight - _chartMargin + xLabelHeight /2.0 );
                labelAddCount = 0;
                
                [_xChartLabels addObject:label];
                [self addSubview:label];
            }
        }
    }
}




-(void)updateChartData:(NSArray *)data{
    self.yValues = data;
    [self updateBar];
}

- (void)getBarLongMax:(NSArray *)xLabels
{
    int max = [[xLabels valueForKeyPath:@"@max.intValue"] intValue];
    
    _xValueMax = (int)max;
    
    if (_xValueMax == 0) {
        _xValueMax = _xMinValue;
    }
}

- (void)getXValueMax:(NSArray *)xLabels
{
    int max = [[xLabels valueForKeyPath:@"@max.intValue"] intValue];
    
    _xValueMax = (int)max;
    
    if (_xValueMax == 0) {
        _xValueMax = _xMinValue;
    }
}

- (void)getYValueMax:(NSArray *)yLabels
{
    int max = [[yLabels valueForKeyPath:@"@max.intValue"] intValue];
    
    _yValueMax = (int)max;
    
    if (_yValueMax == 0) {
        _yValueMax = _yMinValue;
    }
}



- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
}

- (void)updateBar
{
    
    //Add bars
    CGFloat chartCavanWidth = self.frame.size.width - _chartLeftMargin-_chartRightMargin - _yLabelWidth-barRightLabelWidth;
    NSInteger index = 0;
    
    for (NSNumber *valueString in _barLongArray) {
        
        PNBar *bar;
        
        if (_bars.count == _barLongArray.count) {
            bar = [_bars objectAtIndex:index];
        }else{
            CGFloat barWidth;
            
            if (_barWidth) {
                barWidth = _barWidth;
            }else{
                if (_showLabel) {
                    barWidth = yLabelHeight *1;
                    
                }
                else {
                    barWidth = yLabelHeight * 1;
                    
                }
            }
            
            float yLabelSectionHeight = (self.frame.size.height - _chartMargin * 2 - xLabelHeight) / _yLabelSum;
            CGFloat barHeight= yLabelSectionHeight * index + _chartMargin;
            bar = [[PNBar alloc] initWithFrame:CGRectMake(_chartLeftMargin+_yLabelWidth, //Bar X position
                                                          barHeight, //Bar Y position
                                                          chartCavanWidth , // Bar witdh
                                                          yLabelHeight)]; //Bar height
            
            //Change Bar Radius
            bar.barRadius = _barRadius;
            
            //Change Bar Background color
            bar.backgroundColor = _barBackgroundColor;
            
            //Bar StrokColor First
            if (self.strokeColor) {
                bar.barColor = self.strokeColor;
            }else{
                bar.barColor = [self barColorAtIndex:index];
            }
            // Add gradient
            bar.barColorGradientStart = _barColorGradientStart;
            
            //For Click Index
            bar.tag = index;
            
            [_bars addObject:bar];
            [self addSubview:bar];
            
            
            

        }
        
        //Height Of Bar
        float value = [valueString floatValue];
        
        [self getXValueMax:_barLongArray];
        float grade = (float)value / (float)_xValueMax;
    
        
        if (isnan(grade)) {
            grade = 0;
        }
        bar.grade = grade;
        
        
        //添加bar上面显示的数字
        
        PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(bar.frame.origin.x+ grade * chartCavanWidth,
                                                                    bar.frame.origin.y,
                                                                    barRightLabelWidth,
                                                                    yLabelHeight)];
        label.text = ((NSNumber *)_barLongArray[index]).stringValue;
        label.backgroundColor=[UIColor clearColor];
        [self addSubview:label];
        
        index += 1;
    }
}

- (void)strokeChart
{
    //Add Labels

    [self viewCleanupForCollection:_bars];


    //Update Bar
    
    [self updateBar];
    
    //Add chart border lines

    if (_showChartBorder) {
        _chartBottomLine = [CAShapeLayer layer];
        _chartBottomLine.lineCap      = kCALineCapButt;
        _chartBottomLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartBottomLine.lineWidth    = 1.0;
        _chartBottomLine.strokeEnd    = 0.0;

        UIBezierPath *progressline = [UIBezierPath bezierPath];

        [progressline moveToPoint:CGPointMake(_chartLeftMargin+_yLabelWidth, self.frame.size.height - xLabelHeight - _chartMargin)];
        [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartRightMargin,  self.frame.size.height - xLabelHeight - _chartMargin)];

        [progressline setLineWidth:1.0];
        [progressline setLineCapStyle:kCGLineCapSquare];
        _chartBottomLine.path = progressline.CGPath;


        _chartBottomLine.strokeColor = PNBlack.CGColor;


        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue = @1.0f;
        [_chartBottomLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];

        _chartBottomLine.strokeEnd = 1.0;

        [self.layer addSublayer:_chartBottomLine];

        //Add left Chart Line

        _chartLeftLine = [CAShapeLayer layer];
        _chartLeftLine.lineCap      = kCALineCapButt;
        _chartLeftLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartLeftLine.lineWidth    = 1.0;
        _chartLeftLine.strokeEnd    = 0.0;

        UIBezierPath *progressLeftline = [UIBezierPath bezierPath];

        [progressLeftline moveToPoint:CGPointMake(_chartLeftMargin+_yLabelWidth, self.frame.size.height - xLabelHeight - _chartMargin)];
        [progressLeftline addLineToPoint:CGPointMake(_chartLeftMargin+_yLabelWidth,  _chartMargin)];

        [progressLeftline setLineWidth:1.0];
        [progressLeftline setLineCapStyle:kCGLineCapSquare];
        _chartLeftLine.path = progressLeftline.CGPath;


        _chartLeftLine.strokeColor = PNBlack.CGColor;


        CABasicAnimation *pathLeftAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathLeftAnimation.duration = 0.5;
        pathLeftAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathLeftAnimation.fromValue = @0.0f;
        pathLeftAnimation.toValue = @1.0f;
        [_chartLeftLine addAnimation:pathLeftAnimation forKey:@"strokeEndAnimation"];

        _chartLeftLine.strokeEnd = 1.0;

        [self.layer addSublayer:_chartLeftLine];
    }
}


- (void)viewCleanupForCollection:(NSMutableArray *)array
{
    if (array.count) {
        [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [array removeAllObjects];
    }
}


#pragma mark - Class extension methods

- (UIColor *)barColorAtIndex:(NSUInteger)index
{
    if ([self.strokeColors count] == [self.yValues count]) {
        return self.strokeColors[index];
    }
    else {
        return self.strokeColor;
    }
}


#pragma mark - Touch detection

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}


- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIView *subview = [self hitTest:touchPoint withEvent:nil];

    if ([subview isKindOfClass:[PNBar class]] && [self.delegate respondsToSelector:@selector(userClickedOnBarAtIndex:)]) {
        [self.delegate userClickedOnBarAtIndex:subview.tag];
    }
}


@end
