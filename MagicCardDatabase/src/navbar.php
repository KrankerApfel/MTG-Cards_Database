<?php /*Tout les liens de cette navbar retourne à une partie spécifique de la page sauf pour la connexion qui renvoie à une autre page contenant
la base de donnée (après avoir finit l'identification). La clé "page" du tableau GET permet de spécifier sur quel page (ou partie de page) on se trouve
et ainsi changer l'onglet actif en conséquence

TODO : intégrer une fonction pour scroll vers la bonne partie de la page en javascript

*/?>
<div class="topnav">
  <ul>
    <li>
      <a <?php if($_GET['page'] == 'top') { ?>  class="active"; $_GET['page'] = 'top';  <?php   }  ?>   href="?page=top">Acceuil</a>
    </li>
    <li>
      <a <?php if($_GET['page']=="a-propos") { ?>  class="active" ; $_GET['page']="a-propos"; <?php   }  ?> href="?page=a-propos">Histoire</a>
    </li>
    <li>
      <a <?php if($_GET['page']=="carte-explication") { ?>  class="active" ; $_GET['page']="carte-explication"; <?php   }  ?> href="?page=carte-explication">Exemple</a>
    </li>
    <li>
      <a <?php if($_GET['page']=="features") { ?>  class="active" ; $_GET['page']="features"; <?php   }  ?> href="?page=features">Features</a>
    </li>
    <li>
      <a <?php if($_GET['page']=="membres") { ?>  class="active"; $_GET['page']="membres"; <?php   }  ?> href ="?page=membres">Qui sommes nous ?</a>
    </li>

    <div class="login-container">
     <form action="/action_page.php">
       <input type="text" placeholder="Username" name="username">
       <input type="password" placeholder="Password" name="psw">
       <button type="submit">Login</button>
     </form>
    </div>
 </ul>
 </div>
</script>
