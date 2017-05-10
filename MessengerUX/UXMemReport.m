//
//  UXMemReport.m
//  MessengerUX
//
//  Created by CPU11815 on 5/10/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMemReport.h"
#import <mach/mach.h>

float report_memory(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        return ((float)info.resident_size / (1024*1024));
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
        return 0;
    }
}
