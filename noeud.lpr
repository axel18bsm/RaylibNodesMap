
program noeud;

{$mode objfpc}{$H+}

uses
  raylib, strings, init;                      // pour chaine de caractères en C - Pchar

var
   index:integer;

begin

  // Charger une image (remplacez "large_image.png" par votre image)
  Pchartxt:='resources/Carte1870.png';


  InitWindow(screenWidth, screenHeight, pchartxt);
  SetTargetFPS(60);

   image := LoadImage(Pchartxt);
  texture := LoadTextureFromImage(image);
  UnloadImage(image); // L'image originale peut être déchargée après la conversion
   // initialisation des ressources
   chargeressource();


  //SetMousePosition(0, 0);

  // Initialiser la caméra 2D
  camera.target := Vector2Create(texture.width / 2, texture.height / 2); // Centrer initialement sur l'image
  camera.offset := Vector2Create(leftBorderWidth, topBorderHeight); // Départ aligné avec les bordures
  camera.rotation := 0;
  camera.zoom := 1.0;

  // Définir les limites de défilement pour eviter le hors zone
  leftLimit := leftBorderWidth;
  topLimit := topBorderHeight;
  rightLimit := texture.width - (screenWidth - rightBorderWidth);
  bottomLimit := texture.height - (screenHeight - bottomBorderHeight);

  while not WindowShouldClose() do
  begin
    // Déplacement de la caméra avec les touches fléchées
    deltaX := 0;
    deltaY := 0;
    if IsKeyDown(KEY_RIGHT) then deltaX := 5;
    if IsKeyDown(KEY_LEFT) then deltaX := -5;
    if IsKeyDown(KEY_DOWN) then deltaY := 5;
    if IsKeyDown(KEY_UP) then deltaY := -5;

    // Appliquer les limites au mouvement
    camera.target.x := camera.target.x + deltaX;
    camera.target.y := camera.target.y + deltaY;

    if camera.target.x < leftLimit then camera.target.x := leftLimit;
    if camera.target.x > rightLimit then camera.target.x := rightLimit;

    if camera.target.y < topLimit then camera.target.y := topLimit;
    if camera.target.y > bottomLimit then camera.target.y := bottomLimit;

    mousePositionmvt :=GetMousePosition(); // on garde la trace du mouvement de la souris sur la fenetre windows

    { #todo : ici découper en 2 parties : edition et chemin }
    // Détecter les clics souris et convertir en coordonnées de la carte
    case Appli.CurrentMode of
      edition : ;
      parcours: ;
    end;
    if IsMouseButtonPressed(MOUSE_BUTTON_LEFT) then
    begin
      mousePosition := GetMousePosition();
      worldPosition := GetScreenToWorld2D(mousePosition, camera);
    end;

    // Générer le texte des coordonnées acrobatie Pascal sur les chaines caracteres
    // conversion d un nombre en text et ensuite d'un string classique en old string Pascal et C.
      Str(trunc(mouseposition.x),untext);  // souris en x single en pascal valeur entiere ou non donc trunc pour conversion str
      Str(trunc(mouseposition.y),untext2);  // souris en y
      phrasetext:='position clic souris fenetre principale x : ' + untext +' y : '+untext2;
      Pchartxt :=pchar(phrasetext);

      Str(trunc(worldPosition.x),untext);  // souris en x
      Str(trunc(worldPosition.y),untext2);
      phrase2text:='position clic souris Carte x : ' + untext +' y : '+untext2;
      Pchartxt2 :=pchar(phrase2text);
    BeginDrawing();
    ClearBackground(RAYWHITE);


       case Appli.CurrentMode of
      edition :
           begin
                // Afficher l'image
                BeginMode2D(camera);
                DrawTexture(texture, 0, 0, WHITE); // Dessiner l'image à la position (0, 0)
                EndMode2D();
          // Dessiner les bordures
          DrawRectangle(0, 0, leftBorderWidth, screenHeight, BLACK); // Bordure gauche
          DrawRectangle(0, 0, screenWidth, topBorderHeight, BLACK); // Bordure haute
          DrawRectangle(0, screenHeight - bottomBorderHeight, screenWidth, bottomBorderHeight, BLACK); // Bordure basse
          DrawRectangle(screenWidth - rightBorderWidth, 0, rightBorderWidth, screenHeight, BLACK); // Bordure droite
          for Index :=1 to 12 do
          begin
             if TBouton[index].afficher=true then DrawTexturev(TBouton[index].latexture, TBouton[index].position, WHITE);
          end;
          DrawText(appli.intituleParag1,1056,10,20,red);
          DrawText(appli.intituleParag2,1056,80,20,red);
          DrawText(appli.intituleParag3,1056,150,20,red);
         // Afficher les informations sur la position du clic
        DrawText('La carte se déplace avec les touches fléchées',leftBorderWidth,screenHeight-90,20,red);
        DrawText(Pchartxt, leftBorderWidth, screenHeight-60, 20, RED);
        DrawText(Pchartxt2, leftBorderWidth, screenHeight-30, 20, RED);
        { #todo : pour la partie affichage, surement 2 parties .1 pour l'edition, le second pour le cheminement a* }
        //
        end;



        parcours:
        begin

        end;

       end;



    EndDrawing();
  end;

  // Libération des ressources
  UnloadTexture(texture);
  CloseWindow();
end.
