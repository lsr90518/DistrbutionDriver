//
//  MDButtonAndDescriptionView.m
//  DistributionDriver
//
//  Created by Lsr on 4/22/15.
//  Copyright (c) 2015 Lsr. All rights reserved.
//

#import "MDButtonAndDescriptionView.h"
#import "MDUtil.h"

@implementation MDButtonAndDescriptionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //icon button
        _iconButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        [_iconButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
        _iconButton.layer.cornerRadius = 1;
        [_iconButton addTarget:self action:@selector(buttonTouched) forControlEvents:UIControlEventTouchUpInside];
        //image view
        [self addSubview:_iconButton];
        
        //description view
        _descriptionView = [[UIView alloc]initWithFrame:CGRectMake(_iconButton.frame.origin.x + _iconButton.frame.size.width - 1, _iconButton.frame.origin.y, frame.size.width - 99, _iconButton.frame.size.height)];
        [_descriptionView setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1]];
        [self addSubview:_descriptionView];
        
    }
    return self;
}

-(void) setIcon:(UIImage *)icon{
    
    float x = 1;
    //too big
    float area = icon.size.width * icon.size.height;
    if (area > 3600) {
        while (1) {
            area = icon.size.width / x * icon.size.height / x;
            if (area >= 1600 && area <= 3600) {
                break;
            } else {
                x++;
            }
        }
    } else if(area < 1600){
        //too small
        while (1) {
            area = icon.size.width / x * icon.size.height / x;
            if (area >= 1600 && area <= 3600) {
                break;
            } else {
                x = x - 0.1;
            }
        }
    }
    
    
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(23, 22, icon.size.width/x, icon.size.height/x)];
    }
    
    [_iconImageView setImage:icon];
    _iconImageView.center = _iconButton.center;
    [_iconButton addSubview:_iconImageView];
    
}

-(void) setDescriptionViewColor:(UIColor *)color {
    [_descriptionView setBackgroundColor:color];
}

-(void) setText:(NSString *)text{
    if (_descriptionLabel == nil) {
        _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, _descriptionView.frame.size.width - 30, 70)];
        _descriptionLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:11];
        _descriptionLabel.textColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1];
        [_descriptionLabel setNumberOfLines:0];
    }
    NSString *labelText = text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:8];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    _descriptionLabel.attributedText = attributedString;
    [_descriptionLabel sizeToFit];
    [_descriptionView addSubview:_descriptionLabel];
}

-(void) setPicture:(UIImage *)picture{
    CGSize imagesize = picture.size;
    NSLog(@"%f %f", imagesize.height,imagesize.width);
    CGSize buttonSize = self.iconButton.frame.size;
    //正方形
    if(imagesize.height == imagesize.width){
        float x = imagesize.height / buttonSize.height;
        imagesize.height = imagesize.height*x;
        imagesize.width = imagesize.width*x;
        picture = [[MDUtil getInstance] imageWithImage:picture scaledToSize:imagesize];
        
        imagesize = picture.size;
    } else if(imagesize.width > imagesize.height) {
        //長方形
        float x = buttonSize.width/imagesize.width;
        imagesize.height = imagesize.height * x;
        imagesize.width = imagesize.width * x;
        picture = [[MDUtil getInstance] imageWithImage:picture scaledToSize:imagesize];
        
    }
    
    
    

    [self.iconButton setImage:picture forState:UIControlStateNormal];
    [self.iconImageView removeFromSuperview];
}


-(void) buttonTouched{
    if ([self.delegate respondsToSelector:@selector(buttonPushed:)]) {
        [self.delegate buttonPushed:self];
    }
}

@end
