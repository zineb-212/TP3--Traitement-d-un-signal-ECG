# TP3--Traitement-d-un-signal-ECG# TP3- Traitement d’un signal ECG

# Objectifs 

- Suppression du bruit autour du signal produit par un électrocardiographe.
- Recherche de la fréquence cardiaque.

# Introduction 

Un électrocardiogramme (ECG) est une représentation graphique de l’activation électrique du cœur à l’aide d’un électrocardiographe. Cette activité est recueillie sur un patient allongé, au repos, par des électrodes posées à la surface de la peau. L’analyse du signal ECG est utile dans le but de diagnostiquer des anomalies cardiaques telles qu’une arythmie, un risque d’infarctus, de maladie cardiaque cardiovasculaire ou encore extracardiaque. 

Ci-dessous, voici un schéma représentant une représentation classique d’une courbe d’un ECG. Ce schéma se nomme un « Complexe QRS » mettant en évidence le bon fonctionnement d’un cycle cardiaque.

<img width="300" alt="1" src="https://user-images.githubusercontent.com/121026257/212536135-795589b5-8876-46ee-89ca-f3c101a3bfb0.PNG">


L’onde P représente la première étape du cycle où les oreillettes (ou atriums) se contractent permettant le passage du sang, à travers les valves auriculoventriculaires, vers les ventricules.Ensuite, le complexe QRS symbolise à la fois la contraction ventriculaire (permettant l’éjection du sang vers les artères) notamment par le pic en R, dans le même temps, le relâchement des oreillettes entraîne le remplissage de celles-ci en attente d’un nouveau cycle).

L’onde T représente le relâchement des ventricules suite à leur contraction.L’enchaînement de ces complexes permet par ailleurs de déterminer la fréquence 
cardiaque, c’est-à-dire le nombre de cycle cardiaque par unité de temps. Une fréquence cardiaque normale est comprise entre 60 et 100 battements par minute, en 
dessous de cette valeur, le patient est en « bradycardie », au-dessus de cette valeur, le patient est en « tachycardie ».

Les signaux ECG sont contaminés avec différentes sources de bruits. Les bruits de hautes fréquences sont provoqués par l’activité musculaire extracardiaque et les interférences dues aux appareils électriques, et des bruits de basses fréquences provoqués par les mouvements du corps liés à la respiration, les changements physicochimiques induits par l’électrode posée sur la peau et les micro variations du flux sanguin. Le filtrage de ces bruits est une étape très importante pour faire un diagnostic réussi. 

# Suppression du bruit provoqué par les mouvements du corps.

1- Chargement du signal dans Matlab à l’aide la commande *load*.
```matlab
clear all
close all
clc
load("ecg.mat");
x=ecg;
```
2-Representation du signal en fonction du temps.  

```matlab
fs=500;
N=length(x)
ts=1/fs
%%Representation du signal en fct du temps
t=(0:N-1)*ts;
plot(t,x);
title("Signal ECG");
```

<img width="806" alt="2" src="https://user-images.githubusercontent.com/121026257/212536524-55658872-8480-4780-97b0-b58e2f174191.PNG">

3-Suppression des bruits à très basse fréquence dues aux mouvements du corps en utilisant un filtre idéal passe-haut.

```matlab
y = fft(x);
f = (0:N-1)*(fs/N);
fshift = (-N/2:N/2-1)*(fs/N);
plot(fshift,fftshift(abs(y)))
title("spectre Amplitude")

%TFD
subplot(2,2,2)
plot(fshift,fftshift(abs(y)))
title("spectre Amplitude")
%spectre Amplitude centré
%suppression du bruit des movements de corps

h = ones(size(A));
fh = 0.5;
index_h = ceil(fh*N/fs);
h(1:index_h)=0;
h(N-index_h+1:N)=0;

%TFDI pour restituer le signal filtré
ecg1_freq = h.*y;
ecg1 =ifft(ecg1_freq,"symmetric");
subplot(211)
plot(t,ecg);

```
4- Tracer le nouveau signal ecg1

```matlab
plot(t,ecg1);
title("ecg1")

```
<img width="981" alt="hhh" src="https://user-images.githubusercontent.com/89936910/210171272-81b47334-ee5d-43a2-8c49-1360c861d64c.png">

 >et noter les différences par rapport au signal d’origine. 
 
 ```matlab
plot(t,A-ecg1);
title("La différence")

```

 <img width="982" alt="QQQ" src="https://user-images.githubusercontent.com/89936910/210171406-ac3be1c9-0000-4324-8456-d5148ca13498.png">

# Suppression des interférences des lignes électriques 50H

>Souvent, l'ECG est contaminé par un bruit du secteur 50 Hz qui doit être supprimé.

5. Appliquer un filtre Notch idéal pour supprimer cette composante. Les filtres Notch sont utilisés pour rejeter une seule fréquence d'une bande de fréquence donnée.

```matlab
% Elimination interference 50Hz
 
Notch = ones(size(A));
fcn = 50;
index_hcn = ceil(fcn*N/fs)+1;
Notch(index_hcn)=0;
Notch(index_hcn+2)=0;

ecg2_freq = Notch.*fft(ecg1);
ecg2 =ifft(ecg2_freq,"symmetric");
```

6. Visualiser le signal ecg2 après filtrage. 
```matlab
plot(t,ecg2);
title("signal filtré")
```
<img width="972" alt="w" src="https://user-images.githubusercontent.com/89936910/210172650-a0eb7ac9-454e-491d-ae05-11c42468be92.png">

# Amélioration du rapport signal sur bruit 

>Le signal ECG est également atteint par des parasites en provenance de l’activité musculaire extracardiaque du patient. La quantité de bruit est proportionnelle à la >largeur de bande du signal ECG. Une bande passante élevée donnera plus de bruit dans les signaux, et limiter la bande passante peut enlever des détails importants du signal.

7. Chercher un compromis sur la fréquence de coupure, qui permettra de préserver la forme du signal ECG et réduire au maximum le bruit. Tester différents choix, puistracer et commenter les résultats
```matlab
pass_bas = zeros(size(A));
fcb = 30;
index_hcb = ceil(fcb*N/fs);
pass_bas(1:index_hcb)=1;
pass_bas(N-index_hcb+1:N)=1;

ecg3_freq = pass_bas.*fft(ecg2);
ecg3 =ifft(ecg3_freq,"symmetric");
subplot(211)
plot(t,ecg,"linewidth",1.5);
xlim([0.5 1.5])
subplot(212)
plot(t,ecg3);
xlim([0.5 1.5])

```
>avec Frequence 30 hz
<img width="991" alt="f" src="https://user-images.githubusercontent.com/89936910/210173263-b5a354fe-3c31-4a69-8b8b-76f05da76c43.png">

>avec fraquence 60 HZ

<img width="991" alt="j" src="https://user-images.githubusercontent.com/89936910/210173412-d31ce145-0960-41de-aa76-f1fcb667729b.png">

>on remarque que le taux d'ondulation de bruit descend

8. Visualiser une période du nouveau signal filtré ecg3 et identifier autant d'ondes que possible dans ce signal (Voir la partie introduction).

```matlab 
plot(t,ecg3);
xlim([0.5 1.5])
```
<img width="900" alt="l" src="https://user-images.githubusercontent.com/89936910/210173609-0dc5bef4-c1db-4fe9-9806-013bfa9a77bf.png">

# Identification de la fréquence cardiaque avec la fonction d’autocorrélation

La fréquence cardiaque peut être identifiée à partir de la fonction d'autocorrélation du signal ECG. Cela se fait en cherchant le premier maximum local après le maximum global (à tau = 0) de cette fonction. 

9. Ecrire un programme permettant de calculer l’autocorrélation du signal ECG, puis de chercher cette fréquence cardiaque de façon automatique. Utiliser ce programme sur le signal traité ecg3 ou ecg2 et sur le signal ECG non traité. NB : il faut limiter l’intervalle de recherche à la plage possible de la fréquence cardiaque. 

```matlab

[c,lags] = xcorr(ecg3,ecg3);
stem(lags/fs,c)

```
10. Votre programme trouve-t-il le bon pouls ? 
<img width="999" alt="k" src="https://user-images.githubusercontent.com/89936910/210174477-df004b0c-b95b-4d42-a0ac-dc971260433d.png">

> Oui on prend la 2 eme pick Frequence = 60*0.921 =54,72 Hz

# 
