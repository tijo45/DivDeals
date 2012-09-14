/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UITabBarItem+WebCache.h"
#import "SDWebImageManager.h"

@implementation UITabBarItem (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    //[self setImage:placeholder forState:UIControlStateNormal];
    self.image =placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    UIImage *img =[[UIImage alloc] initWithCGImage:[image CGImage] scale:2.0 orientation:UIImageOrientationUp];
    //homeNav.tabBarItem.image =img;

    self.image = img;
    //[self setImage:image forState:UIControlStateNormal];
}

@end
