//
//  PNBarChart.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNBar.h"

#define xLabelMargin 15
#define yLabelMargin 15
#define yLabelHeight 20
#define xLabelHeight 20
#define barRightLabelWidth 20 //bar右边的label宽度


typedef NSString *(^PNXLabelFormatter)(CGFloat yLabelValue);
typedef NSString *(^PNYLabelFormatter)(CGFloat yLabelValue);

@interface PNBarChart : UIView

/**
 * Draws the chart in an animated fashion.
 */
- (void)strokeChart;

@property (nonatomic) NSArray *xLabels;
@property (nonatomic) NSArray *yLabels;
@property (nonatomic) NSArray *yValues;
@property (nonatomic) NSArray *xValues;

@property (nonatomic) NSMutableArray * bars;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) CGFloat yLabelWidth;
@property (nonatomic) int yValueMax;
@property (nonatomic) int xValueMax;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) NSArray *strokeColors;
@property (nonatomic) NSArray *barLongArray;


/** Update Values. */
- (void)updateChartData:(NSArray *)data;

/** Formats the xlabel text. */
@property (copy) PNXLabelFormatter xLabelFormatter;

/** Formats the ylabel text. */
@property (copy) PNYLabelFormatter yLabelFormatter;


@property (nonatomic) CGFloat chartMargin;

/** 图表y轴以左的留白. */
@property (nonatomic) CGFloat chartLeftMargin;

/** 图表右边的留白. */
@property (nonatomic) CGFloat chartRightMargin;

/** Controls whether labels should be displayed. */
@property (nonatomic) BOOL showLabel;

/** Controls whether the chart border line should be displayed. */
@property (nonatomic) BOOL showChartBorder;

/** Chart bottom border, co-linear with the x-axis. */
@property (nonatomic) CAShapeLayer * chartBottomLine;

/** Chart left border, co-linear with the y-axis. */
@property (nonatomic) CAShapeLayer * chartLeftLine;

/** Corner radius for all bars in the chart. */
@property (nonatomic) CGFloat barRadius;

/** Width of all bars in the chart. */
@property (nonatomic) CGFloat barWidth;

@property (nonatomic) CGFloat labelMarginTop;

/** Background color of all bars in the chart. */
@property (nonatomic) UIColor * barBackgroundColor;

/** Text color for all bars in the chart. */
@property (nonatomic) UIColor * labelTextColor;

/** Font for all bars in the chart. */
@property (nonatomic) UIFont * labelFont;

/** How many labels on the x-axis to skip in between displaying labels. */
@property (nonatomic) NSInteger xLabelSkip;

/** How many labels on the x-axis to skip in between displaying labels. */
@property (nonatomic) NSInteger xLabelSum;

/** How many labels on the y-axis to skip in between displaying labels. */
@property (nonatomic) NSInteger yLabelSum;

/** The maximum for the range of values to display on the y-axis. */
@property (nonatomic) CGFloat yMaxValue;

/** The maximum for the range of values to display on the x-axis. */
@property (nonatomic) CGFloat xMaxValue;

/** The minimum for the range of values to display on the x-axis. */
@property (nonatomic) CGFloat xMinValue;

/** The minimum for the range of values to display on the y-axis. */
@property (nonatomic) CGFloat yMinValue;

/** Controls whether each bar should have a gradient fill. */
@property (nonatomic) UIColor *barColorGradientStart;

/** Controls whether text for x-axis be straight or rotate 45 degree. */
@property (nonatomic) BOOL rotateForXAxisText;

@property (nonatomic, retain) id<PNChartDelegate> delegate;

@end
