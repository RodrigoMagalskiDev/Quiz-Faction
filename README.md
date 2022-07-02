# Quiz Faction 

App oficial da Expofred 2022 para a realização de pesquisas de satisfação com os frequentadores e expositores da feira.


## Sobre o app

  O Quiz Faction foi um app desenvolvido para atender a uma demanda de um grupo de pesquisadores da UFSM-FW (Universidade Federal de Santa Maria campus Frederico Westphalen - RS). Este grupo tinha por objetivo coletar dados de frequentadores e expositores da feira multissetorial da cidade de Frederico Westphalen, que fica na região norte do RS.

  Para facilitar a coleta de dados e opiniões dos entrevistados, o Quiz Faction possibilita preencher formulários personalizados para cada tipo de entrevistado, podendo funcionar sem a dependência de conexão com a internet no momento da entrevista. O entrevistador abre o formulário desejado e então preenche-o com os dados coletados e após a finalização do questionário, o mesmo é salvo localmente no dispositivo, em um banco de dados Sqlite. Posteriormente, é possível fazer o envio dos formulários para um servidor em nuvem (Firebase) onde todos os formulários preenchidos ficam salvos.
  
  O grande diferencial deste app, é a possibilidade de criar formulários personalizados e trabalhar de forma offline na maior parte do tempo, realizando a sincronização dos dados, uma vez ao dia!
  
  
## Telas do aplicativo
:iphone: *Como o app não está mais disponível em produção, pois o banco de dados ja foi desativado, deixo abaixo algumas imagens ilustrativas sobre o app*



:large_blue_circle: Telas de Login e Cadastro de Usuário

![login](https://user-images.githubusercontent.com/108557225/176982543-057b4cf6-9769-4de3-908d-1016402ec00d.png)  ![cadastro](https://user-images.githubusercontent.com/108557225/176982751-94c1543c-6d0a-4bd8-bd1f-f1f0379fc8d9.png)

:large_blue_circle: Listagem de questionários

![formularios](https://user-images.githubusercontent.com/108557225/176982620-cd4620f7-38c0-4729-9269-17997088c6b1.png)  ![formulario_2](https://user-images.githubusercontent.com/108557225/176983567-fe546438-a385-48bd-8b5c-9207aaa2a003.png)

:large_blue_circle: Questionário

![detalhe](https://user-images.githubusercontent.com/108557225/176983637-de6b3438-57ec-468f-99db-5c4f644fe936.png)  ![questionario](https://user-images.githubusercontent.com/108557225/176982684-d0b0c863-af60-4470-9b67-c4259db9ad7f.png)


  

## Recursos do app

 -  Autenticação com o Firebase Authentication;
 -  Segurança de formulários com definição de senha;
 -  Uso de forma offline utilizando banco de dados Sqlite;
 -  Persistencia de dados em nuvem com Firestore Database;
 -  Uso offline;


## Detalhes
  O Quiz Faction foi uma ideia que utilizei para desenvolver meu TGSI (trabalho de graduação de Sistemas de Informação - o famoso TCC) que tinha como estudo de caso, a Expofred 2022, uma feira de exposições que ocorre na minha cidade, Frederico Westphalen - RS. O projeto teve uma grande aprovação dos professores e outros interessados, onde então decidimos aplicá-lo durante a feira de exposições, como um projeto-piloto.
  Como esse app foi desenvolvido sob demanda, e o mesmo deveria ser de uso privado, decidi subir o apk para a nuvem, e disponibilizar o link de download apenas para uma lista de entrevistadores aprovados. A ideia deu certo, e ao final da feira, gerei um arquivo em excel, exportando todos os dados coletados para que as análises pudessem ser feitas.
  O app seguiu uma definição de projeto feita pelo grupo de pesquisadores, que passou a ideia principal, e através de algumas conversas, definimos a estrutura de funcionamento, gerenciamento e detalhes de layout.
  
  
  *Este foi meu primeiro projeto colocado em produção, onde pude aprender muito. Atualmente este aplicativo encontra-se desativado, por ter seu uso aplicado apenas durante a feira.*
