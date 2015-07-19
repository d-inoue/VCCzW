@test 'check mysql server listens on 3306' {
    sudo netstat -plnt | grep 3306
}

@test 'check list databases' {
    sudo mysql -h localhost -uroot -pilovestrongpasswords -e 'show databases;'
}
