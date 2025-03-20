unit Init;

{$mode ObjFPC}{$H+}



interface

uses
  Classes, SysUtils,raylib;
type
   TMode =(edition,parcours);
   TFormat=(carre, rond,direction,Bidirection);
   TDirection=(AR,Aller);

   T_App =record
      Id:Integer;
      lenom:PChar;
      CurrentMode: TMode;
      CurrentFormat:TFormat;
      CurrentDirection:TDirection;
      intituleTitre: PChar;
      intituleParag1: PChar;
      intituleParag2: PChar;
      intituleParag3: PChar;
      PosIntituleTitre:TVector2;       //ecriture sur titre
      posintituleParag1:TVector2;
      posintituleParag2:TVector2;      // ecriture sur panel1
      posintituleParag3:TVector2;
      panel:TRectangle;   // panel titre
      paneldebugger:TRectangle;   // panel 1
      couleursupportTitre:TColor;
   end;

   t_button = record
      Id: Integer;
      Fileimage:pchar;        // chemin de mon dessin normal
      latexture:TTexture2D;   // le dessin est stocké
      limage:TImage;          //nomdufichier normal
      position :tvector2;      //position bouton
      afficher:Boolean;       // est il affiché ?
   end;

var
 // Taille de la fenêtre
  screenWidth:Integer =1280;
  screenHeight :integer= 800;
  // Dimensions des bordures
  leftBorderWidth :integer= 0;
  topBorderHeight :integer= 0;
  bottomBorderHeight :integer= 100;
  rightBorderWidth :integer= 250;
  Appli:T_App;
  TBouton:Array[1..12]of t_button;
  TImgBouton:Array[1..8]of integer;        //n°image à afficher  image impaire sélection, pair non sélection
  camera: TCamera2D;
  image: TImage;
  texture: TTexture2D;
  mousePosition, mousePositionmvt: TVector2;
  worldPosition: TVector2;
  deltaX, deltaY: Single;
  leftLimit, topLimit, rightLimit, bottomLimit: Single;
  untext,untext2,phrasetext,phrase2text: String;
  Pchartxt:PChar ='resources/Carte1870.png';                 // carte principale
  Pchartxt2:pchar;



procedure chargeressource;

 implementation
procedure chargeressource;


  begin
       with Appli do                  // objet jeu
       begin
       Id:=1;
      lenom:='Noeud, Direction, A*';
      CurrentMode:=edition;
      CurrentFormat:=carre;
      CurrentDirection:=AR;

      panel:=RectangleCreate(1250,5,425,60);
      paneldebugger:=RectangleCreate(1250,5,425,60);
      intituleTitre:= 'Noeud, Direction, A*';
      intituleParag1:= 'Mode Fonctionnement';
      intituleParag2:= 'Format Node';
      intituleParag3:='Format Direction';
      couleursupportTitre:=RAYWHITE;
       end;

       //chargement image des boutons
       TBouton[1].fileimage:='resources/editionok.png';
       TBouton[1].limage := LoadImage(TBouton[1].Fileimage);
       TBouton[1].latexture :=LoadTextureFromImage(TBouton[1].limage);
       TBouton[1].position :=Vector2Create(1055,41);
       TBouton[1].afficher :=true;


       TBouton[2].fileimage:='resources/edition.png';
       TBouton[2].limage := LoadImage(TBouton[2].Fileimage);
       TBouton[2].latexture := LoadTextureFromImage(TBouton[2].limage);
       TBouton[2].position :=Vector2Create(1055,41);
       TBouton[2].afficher :=false;

       TBouton[3].fileimage:='resources/cheminok.png';
       TBouton[3].limage := LoadImage(TBouton[3].Fileimage);
       TBouton[3].latexture := LoadTextureFromImage(TBouton[3].limage);
       TBouton[3].position :=Vector2Create(1180,41);
       TBouton[3].afficher :=false;

       TBouton[4].fileimage:='resources/chemin.png';
       TBouton[4].limage := LoadImage(TBouton[4].Fileimage);
       TBouton[4].latexture := LoadTextureFromImage(TBouton[4].limage);
       TBouton[4].position :=Vector2Create(1180,41);
       TBouton[4].afficher :=true;

       TBouton[5].fileimage:='resources/carreok.png';
       TBouton[5].limage := LoadImage(TBouton[5].Fileimage);
       TBouton[5].latexture := LoadTextureFromImage(TBouton[5].limage);
       TBouton[5].position :=Vector2Create(1055,105);
       TBouton[5].afficher :=true;

       TBouton[6].fileimage:='resources/carre.png';
       TBouton[6].limage := LoadImage(TBouton[6].Fileimage);
       TBouton[6].latexture := LoadTextureFromImage(TBouton[6].limage);
       TBouton[6].position :=Vector2Create(1055,105);
       TBouton[6].afficher :=false;

       TBouton[7].fileimage:='resources/rondok.png';
       TBouton[7].limage := LoadImage(TBouton[7].Fileimage);
       TBouton[7].latexture := LoadTextureFromImage(TBouton[7].limage);
       TBouton[7].position :=Vector2Create(1180,105);
       TBouton[7].afficher :=false;

       TBouton[8].fileimage:='resources/rond.png';
       TBouton[8].limage := LoadImage(TBouton[8].Fileimage);
       TBouton[8].latexture := LoadTextureFromImage(TBouton[8].limage);
       TBouton[8].position :=Vector2Create(1180,105);
       TBouton[8].afficher :=true;

       TBouton[9].fileimage:='resources/arok.png';
       TBouton[9].limage := LoadImage(TBouton[9].Fileimage);
       TBouton[9].latexture := LoadTextureFromImage(TBouton[9].limage);
       TBouton[9].position :=Vector2Create(1055,169);
        TBouton[9].afficher :=false;

       TBouton[10].fileimage:='resources/arnok.png';
       TBouton[10].limage := LoadImage(TBouton[10].Fileimage);
       TBouton[10].latexture := LoadTextureFromImage(TBouton[10].limage);
       TBouton[10].position :=Vector2Create(1055,169);
       TBouton[10].afficher :=true;

       TBouton[11].fileimage:='resources/allerok.png';
       TBouton[11].limage := LoadImage(TBouton[11].Fileimage);
       TBouton[11].latexture := LoadTextureFromImage(TBouton[11].limage);
       TBouton[11].position :=Vector2Create(1180,169);
        TBouton[11].afficher :=false;

       TBouton[12].fileimage:='resources/allernok.png';
       TBouton[12].limage := LoadImage(TBouton[12].Fileimage);
       TBouton[12].latexture := LoadTextureFromImage(TBouton[12].limage);
       TBouton[12].position :=Vector2Create(1180,169);
       TBouton[12].afficher :=true;




 end;
end.


