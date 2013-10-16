<?php
echo file_get_contents('http://gamli.ja.is/kort/search_json/?'.$_SERVER['QUERY_STRING']);
