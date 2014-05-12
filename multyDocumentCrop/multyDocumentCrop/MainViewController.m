//
//  MainViewController.m
//  multyDocumentCrop
//
//  Created by Daniele Ceglia on 09/05/14.
//  Copyright (c) 2014 Relifeit. All rights reserved.
//

#import "MainViewController.h"

// DIMENSIONI FOGLIO A4
// larghezza mm: 210 pollici: 8.2677   per 300 dpi: 2480.31  (2480) per 150 dpi: 1240.155  (1240)
// altezza   mm: 297 pollici: 11.69289 per 300 dpi: 3507.867 (3508) per 150 dpi: 1753.9335 (1754)
#define larghezzaPagina         1240
#define altezzaPagina           1754

@interface MainViewController ()
{
    NSMutableArray *arrayImmaginiScattateJPEG;
    CGSize pageSize;
    NSString *percorsoFilePDF;
    NSString *documentsDirectory;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    arrayImmaginiScattateJPEG = [[NSMutableArray alloc] init];
    
    pageSize = CGSizeMake(larghezzaPagina, altezzaPagina);
    NSString *fileName = @"Demo.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    percorsoFilePDF = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [_anteprima loadRequest:
     [NSURLRequest requestWithURL:
      [NSURL fileURLWithPath:
       [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"] isDirectory:NO]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Action's methods

- (IBAction)iniziaTest:(id)sender
{
    NSLog(@"iniziaTest...");
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Elabora foto da"
                                                       delegate:self
                                              cancelButtonTitle:@"Annulla"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Scatta nuova", @"Prendi da libreria", nil];
    
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MAImagePickerController *imagePicker = [[MAImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    if (buttonIndex == 1)
    {
        imagePicker.sourceType = MAImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //imagePicker.sourceType = MAImagePickerControllerSourceTypeCamera;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePicker];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Private methods

- (void)disegnaImmagine:(UIImage *)immagineCorrente
{
    [immagineCorrente drawInRect:CGRectMake(0, 0, immagineCorrente.size.width, immagineCorrente.size.height)];
}

- (void)generaPDF
{
    UIGraphicsBeginPDFContextToFile(percorsoFilePDF, CGRectZero, nil);
    
    int paginaCorrente = 0;
    int numeroPagine = (int)[arrayImmaginiScattateJPEG count];
    
    while (paginaCorrente < numeroPagine)
    {
        // inizio una nuova pagina
        
        NSString *percorsoImmagineCorrente = arrayImmaginiScattateJPEG[paginaCorrente];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:percorsoImmagineCorrente];
        UIImage *immagineCorrente = [UIImage imageWithData:data];
        
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, immagineCorrente.size.width, immagineCorrente.size.height), nil);
        
        [self disegnaImmagine:immagineCorrente];
        
        paginaCorrente++;
    }
    
    // chiudo il contesto del PDF e creo il file!
    UIGraphicsEndPDFContext();
    
    // carico il pdf appena creato sulla webview
    NSURL *url = [NSURL fileURLWithPath:percorsoFilePDF];
    NSURLRequest *richiestaURL = [NSURLRequest requestWithURL:url];
    [_anteprima loadRequest:richiestaURL];
}

- (void)copiaFileDaPercorso:(NSString *)percorsoOrigine aPercorsoDestinazione:(NSString *)percorsoDestinazione
{
    NSError *errore;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:percorsoDestinazione])
    {
        // se il file esiste già lo cancello, che poi lo devo sovrascrivere...
        
        [[NSFileManager defaultManager] removeItemAtPath:percorsoDestinazione error:&errore];
        
        if (errore)
        {
            NSLog(@"Errore cancellazione: %@", [errore localizedDescription]);
            
            return;
        }
    }
    
    // copio file...
    
    [[NSFileManager defaultManager] copyItemAtPath:percorsoOrigine
                                            toPath:percorsoDestinazione
                                             error:&errore];
    
    if (errore)
    {
        NSLog(@"Errore scrittura: %@", [errore localizedDescription]);
    }
}

#pragma mark - MAImagePickerControllerDelegate

- (void)imagePickerDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerDidChooseImageWithPath:(NSString *)path
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSLog(@"File Found at %@", path);
        
        NSString *percorsoFileCopiato = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", (int)[arrayImmaginiScattateJPEG count] + 1]];
        
        [self copiaFileDaPercorso:path aPercorsoDestinazione:percorsoFileCopiato];
        
        [arrayImmaginiScattateJPEG addObject:percorsoFileCopiato];
        
        [self generaPDF];
    }
    else
    {
        NSLog(@"No File Found at %@", path);
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

@end
