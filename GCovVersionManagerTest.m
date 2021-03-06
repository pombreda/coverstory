//
//  GCovVersionManagerTest.m
//  CoverStory
//
//  Created by Thomas Van Lenten on 6/2/10.
//  Copyright 2010 Google Inc.
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

#import "GTMSenTestCase.h"
#import "GCovVersionManager.h"

@interface GCovVersionManagerTest : SenTestCase
@end


@implementation GCovVersionManagerTest

- (void)testCollectionOfInstalled {
  GCovVersionManager *mgr = [GCovVersionManager defaultManager];
  STAssertNotNil(mgr, nil);

  // default should not be an empty string
  STAssertNotNil([mgr defaultGCovPath], nil);
  STAssertGreaterThan([[mgr defaultGCovPath] length], (NSUInteger)0, nil);

  // Should be atleast the default in the list.
  STAssertNotNil([mgr installedVersions], nil);
  STAssertGreaterThanOrEqual([[mgr installedVersions] count], (NSUInteger)1, nil);
}

- (void)testVersionCheck {
  // The test files were generated by building and running this little app:
  //  gcc-4.0 -arch ppc -fprofile-arcs -ftest-coverage test.c -o test
  //  gcc-4.0 -arch i386 -fprofile-arcs -ftest-coverage test.c -o test
  //  gcc-4.0 -arch x86_64 -fprofile-arcs -ftest-coverage test.c -o test
  //  gcc-4.2 -arch ppc -fprofile-arcs -ftest-coverage test.c -o test
  //  gcc-4.2 -arch i386 -fprofile-arcs -ftest-coverage test.c -o test
  //  gcc-4.2 -arch x86_64 -fprofile-arcs -ftest-coverage test.c -o test
  //  xcrun clang -arch i386 -fprofile-arcs -ftest-coverage test.c -o test
  //  xcrun clang -arch x86_64 -fprofile-arcs -ftest-coverage test.c -o test
  //    #include <stdio.h>
  //    int main(int ac, char** av) {
  //      int i;
  //      for (i = 0; i < 10 ; ++i)
  //        printf("i = %d\n", i);
  //      return 0;
  //    }

  GCovVersionManager *mgr = [GCovVersionManager defaultManager];
  STAssertNotNil(mgr, nil);
  NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
  STAssertNotNil(testBundle, nil);

  struct TestDataRecord {
    NSString *name;
    NSString *version;
  } testData[] = {
    { @"test_i386_4_0.gcda", @"4.0" },
    { @"test_i386_4_0.gcno", @"4.0" },
    { @"test_i386_4_2.gcda", @"4.2" },
    { @"test_i386_4_2.gcno", @"4.2" },
    { @"test_i386_clang_4_2.gcda", @"4.2" },
    { @"test_i386_clang_4_2.gcno", @"4.2" },
    { @"test_ppc_4_0.gcda", @"4.0" },
    { @"test_ppc_4_0.gcno", @"4.0" },
    { @"test_ppc_4_2.gcda", @"4.2" },
    { @"test_ppc_4_2.gcno", @"4.2" },
    { @"test_x86_64_4_0.gcda", @"4.0" },
    { @"test_x86_64_4_0.gcno", @"4.0" },
    { @"test_x86_64_4_2.gcda", @"4.2" },
    { @"test_x86_64_4_2.gcno", @"4.2" },
    { @"test_x86_64_clang_4_2.gcda", @"4.2" },
    { @"test_x86_64_clang_4_2.gcno", @"4.2" },
  };

  for (size_t x = 0; x < sizeof(testData)/sizeof(testData[0]); ++x) {
    NSString *path = [testBundle pathForResource:testData[x].name
                                          ofType:nil];
    STAssertEqualObjects([mgr versionFromGCovFile:path],
                         testData[x].version,
                         @"index %zu - path: %@", x, path);
  }

  // Feed it something that doesn't have magic on the front and doesn't exist
  STAssertNil([mgr versionFromGCovFile:@"/etc/passwd"], nil);
  STAssertNil([mgr versionFromGCovFile:@"/does/not/exist"], nil);
  STAssertNil([mgr versionFromGCovFile:@""], nil);
  STAssertNil([mgr versionFromGCovFile:nil], nil);
}

@end
