<?php
  //phpinfo();
  require __DIR__.'/../grpc/examples/php/vendor/autoload.php';
  require __DIR__.'/../helloworld.php';
  $client = new helloworld\GreeterClient('0.0.0.0:50051', []);
  $req = new helloworld\HelloRequest();
  $req->setName('Daniel');
  list($reply, $status) = $client->SayHello($req)->wait();

  echo "<pre>".$reply->getMessage()."</pre>";
?>

