//
//  JRUploadIdCardViewController.m
//  Double
//
//  Created by 何崇 on 2017/11/29.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "JRUploadIdCardViewController.h"
#import "CSIICustomTextField.h"
#import "JRUploadIDCardSuccessViewController.h"
#import "JRSYHttpTool.h"

#define SCALE (ScreenWidth/320)
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface JRUploadIdCardViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate>
{
    NSArray *idImageViewArray;//身份证imageView数组
    NSArray *idImageArray;//身份证image数组
    NSArray *idImageTipsArray;//身份证image数组

    NSString *picPath_SFZ_1;
    NSString *picPath_SFZ_2;
    NSString *picPath_SFZ_3;

    UIImageView *userId_front;//正面
    UIImageView *userId_back;//反面
    UIImageView *userId_hand;//手持照

    UIImage *frondImg;
    UIImage *bakcImg;
    UIImage *handImg;

    NSInteger curTap;

    CSIICustomTextField *phoneTF;
    CSIICustomTextField *nameTF;

    UIImagePickerController *imagePicker;

    UIScrollView *scrollView;


}

@end

@implementation JRUploadIdCardViewController

- (id)init{
    self = [super init];
    if (self) {

    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];

    self.title = @"实名认证";

}

- (void)loadView{
    [super loadView];
    curTap = 0;

    userId_front = [[UIImageView alloc]init];
    userId_back = [[UIImageView alloc]init];
    userId_hand = [[UIImageView alloc]init];

    idImageViewArray = @[userId_hand, userId_front, userId_back];
    idImageArray = @[@"uploadhead", @"uploadfront", @"uploadreverse"];
    idImageTipsArray = @[@"拍摄身份证正面", @"拍摄身份证背面", @"手持身份证照片"];

}



- (void)viewDidLoad {
    [super viewDidLoad];

    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+200);
    [self.view addSubview:scrollView];

    scrollView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];


    UIImageView *lineOne = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 0, DeviceWidth, 49)];
    lineOne.backgroundColor = [UIColor whiteColor];
    lineOne.userInteractionEnabled = YES;


    UIImageView *line1 = [[UIImageView alloc] initWithFrame:ScaleFrame(15, 48, 360, 1)];
    line1.backgroundColor = RGB_COLOR(235,236,237);
    [lineOne addSubview:line1];

    UILabel *l = [[UILabel alloc] initWithFrame:ScaleFrame(15, 18, 78-15, 14)];
    l.text = @"姓   名:";
    l.font = DeviceFont(15);
    l.textColor = AllTextColorTit;
    [lineOne addSubview:l];

    phoneTF = [[CSIICustomTextField alloc]
               initWithFrame:ScaleFrame(78,0, DeviceWidth-78,48)];
    phoneTF.delegate = self;
    phoneTF.tag = 1;
    phoneTF.font = [UIFont systemFontOfSize:14.0];
    phoneTF.backgroundColor = [UIColor clearColor];
    phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入真实姓名" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:[UIFont systemFontOfSize:AllTextFont]}];
    [lineOne addSubview:phoneTF];
    [scrollView addSubview:lineOne];


    UIImageView *lineTwo = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 49, DeviceWidth, 49)];
    lineTwo.backgroundColor = [UIColor whiteColor];
    lineTwo.userInteractionEnabled = YES;


    UILabel *l2 = [[UILabel alloc] initWithFrame:ScaleFrame(15, 18, 78-15, 14)];
    l2.text = @"身份证:";
    l2.font = DeviceFont(15);
    l2.textColor = AllTextColorTit;
    [lineTwo addSubview:l2];

    nameTF = [[CSIICustomTextField alloc]
              initWithFrame:ScaleFrame(78,0, DeviceWidth-78,48)];
    nameTF.delegate = self;
    nameTF.font = [UIFont systemFontOfSize:AllTextFont];
    nameTF.backgroundColor = [UIColor clearColor];
    nameTF.keyboardType = UIKeyboardTypeASCIICapable;
    nameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入身份证号码" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    nameTF.tag = 2;
    [lineTwo addSubview:nameTF];
    [scrollView addSubview:lineTwo];

    //这里设个全局变量 在启动时制空
    //        NSArray *arr = @[idString1,idString2,idString3];
    //        NSLog(@"%@",arr);
    [idImageArray enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * stop) {


        UILabel *tipLabel = [[UILabel alloc] initWithFrame:ScaleFrame(139, 117+idx*(135+42), 100, 13)];
        tipLabel.font = DeviceFont(14);
        tipLabel.text = idImageTipsArray[idx];
        tipLabel.textColor = RGB_COLOR(102,102,102);
        [scrollView addSubview:tipLabel];



        UIImageView *imageView = idImageViewArray[idx];
        imageView.frame = ScaleFrame(78, 141+idx*(135+42), 218, 135);
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.image = JRBundeImage(idImageArray[idx]);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = 1001+idx;


        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getUserIdImage:)];
        [imageView addGestureRecognizer:tap];
        [scrollView addSubview:imageView];


        UIImageView *cameraView = [[UIImageView alloc] init];
        cameraView.frame = ScaleFrame(77, 34, 65, 65);
        cameraView.userInteractionEnabled = YES;
        cameraView.image = JRBundeImage(@"camera");
        cameraView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView addSubview:cameraView];




        UIView *seeAboutView = [[UIView alloc] initWithFrame:ScaleFrame(204, 645, 16+76, 16)];
        seeAboutView.userInteractionEnabled = YES;
        [scrollView addSubview:seeAboutView];

        //
        //            CSIILabelButton * seeAbout = [[CSIILabelButton alloc] init];
        //            [seeAbout  setImage:JRBundeImage(@"seeAbout") frame:ScaleFrame(0, 0, 16, 16) forState:UIControlStateNormal];
        //            [seeAbout setLabel:@"查看拍摄要求" frame:ScaleFrame(22, 2, 76, 12)];
        //            seeAbout.label.font = DeviceFont(12);
        //            seeAbout.label.textColor = RGB_COLOR(122,123,135);
        //            seeAbout.userInteractionEnabled = YES;
        //            [seeAboutView addSubview:seeAbout];
        //
        //
        //            UITapGestureRecognizer *tapSeeAbout = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeAboutAction)];
        //            [seeAboutView addGestureRecognizer:tapSeeAbout];

    }];

    UIButton *nextButton = [[UIButton alloc]initWithFrame:ScaleFrame(25, 684, 325, 43)];
    nextButton.backgroundColor = RGB_COLOR(37,150,194);
    nextButton.layer.cornerRadius = 5;
    nextButton.titleLabel.font = DeviceFont(18);
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:nextButton];

}

#pragma mark - 输入框代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if (textField.tag == 1) {
        if (textField.text.length >= kMaxLengthName) return NO;

    }else if(textField.tag == 2){

        if (textField.text.length >= kMaxLengthIdCard) return NO;

    }
    return YES;
}


- (void)seeAboutAction{
    alertMsg(@"查看拍摄要求");
}

-(void)nextButtonAction{
    //    [JRJumpClientToVx jumpWithZipID:@"InterestTrial" controller:self];

    if (phoneTF.text.length == 0) {
        alertMsg(@"姓名不能为空！");
    }if (nameTF.text.length == 0) {
        alertMsg(@"身份证不能为空！");
    }


    if (![JRPattern CheckIsIdentityCard:nameTF.text]) {
        alertMsg(@"身份证格式不正确！");
        return;
    }


    NSString *str ;
    if (!picPath_SFZ_1) {
        str = @"本人身份证正面照片还没有拍摄";
    }else if (!picPath_SFZ_2){
        str = @"本人身份证反面照片还没有拍摄";
    }else if(!picPath_SFZ_3){
        str = @"本人手持身份证照片还没有拍摄";
    }

    if(str!=nil){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }



    NSMutableDictionary *img_params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
    NSMutableDictionary *fileDic = [[NSMutableDictionary alloc] init];
    [fileDic setObject:picPath_SFZ_2 forKey:@"ImgFile1"];
    [fileDic setObject:picPath_SFZ_3 forKey:@"ImgFile2"];
    [fileDic setObject:picPath_SFZ_1 forKey:@"ImgFile3"];


    [img_params setObject:@"3" forKey:@"counter"];
    [img_params setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:@"UserId"];


    [img_params setObject:@"SFZ_1" forKey:@"ImgType1"];
    [img_params setObject:@"SFZ_2" forKey:@"ImgType2"];
    [img_params setObject:@"SFZ_3" forKey:@"ImgType3"];
    [img_params setObject:fileDic forKey:@"file"];


    //        [img_params setObject:picPath  forKey:@"ImgFile1"];

    new_transaction_caller
    caller.transactionId = @"PublicImgUpload.do";
    caller.webMethod = POST;
    caller.transactionArgument=img_params;
    caller.responsType = ResponsTypeOfImageData;
    execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
        if (TransactionIsSuccess) {
            DebugLog(@"哈哈哈");
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
            [params setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:@"UserId"];
            [params setObject:phoneTF.text forKey:@"UserName"];

            //小写x替换为X
            NSString *idNoStr = nameTF.text;

            if ([idNoStr rangeOfString:@"x"].location != NSNotFound) {
                idNoStr = [idNoStr stringByReplacingOccurrencesOfString:@"x" withString:@"X"];
            }

            [params setObject:idNoStr forKey:@"IdNo"];


            [NickMBProgressHUD showMessage:@"请稍后"];
            [JRSYHttpTool post:@"RealNameAuth.do" parameters:params success:^(id json) {
                [NickMBProgressHUD hideHUD];
                if (json[@"_RejCode"]  && ![json[@"_RejCode"] isEqualToString:@"000000"]) {
                    alertView(json[@"jsonError"]);
                }

                Singleton.isLogin = YES;
                Singleton.userInfo = json;
                [[NSUserDefaults standardUserDefaults] setObject:json[@"UserId"] forKey:kUserId];
                [[NSNotificationCenter defaultCenter] postNotificationName:Login_Notification object:nil];



                JRUploadIDCardSuccessViewController *p = [[JRUploadIDCardSuccessViewController alloc]init];
                [self.navigationController pushViewController:p animated:YES];

                [Singleton removeAllPic];

            } failure:^(NSError *error) {
                [NickMBProgressHUD hideHUD];

            }];
        }else{
            alerErr
        }
    }));


}
- (void)ddd{

}
- (void)getUserIdImage:(UITapGestureRecognizer *)tapGesture
{

    curTap = tapGesture.view.tag;

    UIActionSheet *aSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册选取", nil];
    aSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [aSheet showInView:self.view];
}

#pragma mark --UITableViewDelegate方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 762*DeviceScaleX;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)compressImage:(UIImage *)image
{
    //拿到图片
    UIImage *imagesave = image;
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    if (curTap == 1001) {
        picPath_SFZ_1 = [path_sandox stringByAppendingString:@"/Documents/picPath_SFZ_1.png"];
        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        [UIImagePNGRepresentation(imagesave) writeToFile:picPath_SFZ_1 atomically:YES];
    }else if (curTap == 1002){

        picPath_SFZ_2 = [path_sandox stringByAppendingString:@"/Documents/picPath_SFZ_2.png"];
        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        [UIImagePNGRepresentation(imagesave) writeToFile:picPath_SFZ_2 atomically:YES];
    }else if (curTap == 1003){

        picPath_SFZ_3 = [path_sandox stringByAppendingString:@"/Documents/picPath_SFZ_3.png"];
        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        [UIImagePNGRepresentation(imagesave) writeToFile:picPath_SFZ_3 atomically:YES];
    }
}

#pragma mark - JRBLMCameraViewControllerDelegate
-(void)cameraFinish:(UIImage *)image
{
    UIImage *imageCurrent = image;
    if (curTap == 1001)
    {
        //frontID.jpg backID.jpg withID.jpg
        handImg = image;
        [self compressImage:image];

    }
    else if (curTap == 1002) {
        frondImg = image;
        [self compressImage:image];
    }
    else if (curTap == 1003) {
        bakcImg = image;
        [self compressImage:image];
    }
    [self setAutherticationImage:imageCurrent];
}


- (void)setAutherticationImage:(UIImage *)img
{
    switch (curTap) {
        case 1001:
        {
            [userId_hand setImage:img];

        }
            break;
        case 1002:
        {
            [userId_front setImage:img];

        }
            break;
        case 1003:
        {
            [userId_back setImage:img];

        }
            break;

        default:
            break;
    }
}
#pragma mark -- UIActionSheetDelegate方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //            DebugLog(@"----------------------");
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

                imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                //                imagePicker.allowsEditing = YES;

                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
            }else{
                DebugLog(@"无法打开相机");
            }
        }
            break;
        case 1:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
            {
                self.edgesForExtendedLayout = UIRectEdgeNone;
                [picker.navigationBar setBackgroundImage:JRBundeImage(@"navBgImage_1.png") forBarMetrics:UIBarMetricsDefault];
            }else{
                if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
                    //
                }
            }
            [UINavigationBar appearance].tintColor = [UIColor blackColor];
            //            picker.allowsEditing = YES;
            picker.delegate=self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

            [self presentViewController:picker animated:YES completion:^{}];
        }
            break;

        default:
            break;
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];//UIImagePickerControllerOriginalImage

    [self cameraFinish:image];//UIImagePickerControllerEditedImage
    [self dismissViewControllerAnimated:YES completion:^{

    }];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
