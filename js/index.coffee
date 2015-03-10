  width               = 1050
  height              = 625
  equilateralAltitude = Math.sqrt(3.0) / 2.0
  triangleScale       = 30
  patch_width         = width * 1.1
  patch_height        = height * 1.1

  # Create patch of triangles that spans the view
  shapeobj = seen.Shapes.tetrahedron()
  shapeback = seen.Shapes.tetrahedron()  

  shape = seen.Shapes.tetrahedron()
  .scale(0.1)
  .translate(0,0,-700)
  .rotx(0)

  model = seen.Models.default().add(shape)

  scene = new seen.Scene
    model    : model
    viewport : seen.Viewports.center(width, height)
    camera   : new seen.Camera
        projection : seen.Projections.ortho()
  
  # Load the object file using jquery
  $.get 'assets/logo.obj', {}, (contents) ->
  # Create shape from object file
    shapeobj = seen.Shapes.obj(contents, false)
    shapeobj.scale(1).translate(0,0,100).rotx(0).roty(0).rotz(0)
  # Update scene model
    seen.Colors.randomSurfaces2(shapeobj)
    model.add(shapeobj)

  $.get 'assets/background.obj', {}, (contents) ->
  # Create shape from object file
    shapeback = seen.Shapes.obj(contents, false)
    shapeback.scale(1).translate(0,0,-100).rotx(0).roty(0).rotz(0)
  # Update scene model
    seen.Colors.randomSurfaces2(shapeback)
    model.add(shapeback)


  context = seen.Context('seen-canvas', scene).render()

# Apply animated 3D simplex noise to patch vertices
  t = 0
  noiser = new Simplex3D(shapeobj)
  context.animate()
    .onBefore((t)->
      for surf in shapeobj.surfaces
        for p in surf.points
          p.z = 4*noiser.noise(p.x/8, p.y/8, t*1e-4)
        # Since we're modifying the point directly, we need to mark the surface dirty
        # to make sure the cache doesn't ignore the change
        surf.dirty = true
    )
    .start()
# Apply animated 3D simplex noise to patch vertices
  t = 0
  noiser = new Simplex3D(shapeback)
  context.animate()
    .onBefore((t)->
      for surf in shapeback.surfaces
        for p in surf.points
          p.z = 20*noiser.noise(p.x/8, p.y/8, t*1e-4)
        # Since we're modifying the point directly, we need to mark the surface dirty
        # to make sure the cache doesn't ignore the change
        surf.dirty = true
    )
    .start()