AddEventHandler('onClientMapStart', function()
  exports.spawnmanager:addSpawnPoint({
    x = 195.55,
    y = -933.36,
    z = 30.69,
    heading = 144.0,
    model = 'a_m_y_skater_01',
    skipFade = false
  })
  exports.spawnmanager:setAutoSpawn(true)
  exports.spawnmanager:forceRespawn()
end)
